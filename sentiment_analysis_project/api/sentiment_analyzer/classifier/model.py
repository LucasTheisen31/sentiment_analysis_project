import json  # Importa o módulo para manipulação de arquivos JSON.

import torch  # Importa a biblioteca PyTorch para trabalhar com tensores e operações em redes neurais
import torch.nn.functional as F  # Importa funções de ativação (neste caso, 'softmax') da biblioteca PyTorch para cálculos adicionais

# Importa a classe 'AutoTokenizer' da biblioteca Transformers para tokenizar texto com base no modelo BERT
from transformers import AutoTokenizer

# Importa a classe 'SentimentClassifier' (modelo de classificação) de um módulo local
from .sentiment_classifier import SentimentClassifier

# Abre o arquivo 'config.json' e carrega seu conteúdo como um dicionário Python.
# Carrega a configuração que contém detalhes como o nome do modelo BERT.
with open("config.json") as json_file:
    config = json.load(json_file)


# Cria a classe Model que carrega um modelo de classificação de sentimentos treinado e faz previsões em novos textos.
class Model:
    def __init__(self):
        self.device = torch.device(
            "cuda:0" if torch.cuda.is_available() else "cpu"
        )  # Verifica se há uma GPU disponível, senão usa a CPU
        self.tokenizer = AutoTokenizer.from_pretrained(config["BASE_MODEL"])
        # Inicializa o tokenizer com o modelo especificado em "config["BASE_MODEL"]"

        classifier = SentimentClassifier(len(config["CLASS_NAMES"]))
        # Cria uma instância do classificador de sentimentos com o número de classes definido nas configurações
        # Carregar o estado do modelo salvo (os pesos) a partir do caminho especificado em "config["PRE_TRAINED_MODEL"]"
        # O parâmetro 'map_location=self.device' garante que os pesos do modelo sejam carregados para o dispositivo correto
        # (seja CPU ou GPU), dependendo da disponibilidade da GPU no sistema.
        state_dict = torch.load(config["PRE_TRAINED_MODEL"], map_location=self.device)
        # coloca strict=False temporariamente
        classifier.load_state_dict(state_dict, strict=False)

        # Move o classificador para o dispositivo configurado (GPU ou CPU)
        classifier = classifier.to(self.device)

        # Coloca o modelo em modo de avaliação (deve ser feito antes da inferência para desativar dropout e batchnorm)
        classifier = classifier.eval()

        self.classifier = classifier

    # Método que realiza a previsão de sentimento para um texto de entrada
    def predict(self, text):
        
        # 1. Tokeniza o texto de entrada e retorna tensores PyTorch prontos para o modelo
        encoded_text = self.tokenizer.encode_plus(
            text,  # O texto que será tokenizado
            # Comprimento máximo da sequência permitida
            max_length=config["MAX_SEQUENCE_LEN"],
            # Adiciona tokens especiais (por exemplo, [CLS] e [SEP])
            add_special_tokens=True,
            # Não retorna IDs de tipo de token, pois não são necessários
            return_token_type_ids=False,
            # Preenche com padding para garantir um tamanho fixo
            padding="max_length",
            # Retorna a máscara de atenção (usada pelo modelo para ignorar padding)
            return_attention_mask=True,
            # Retorna os dados como tensores PyTorch
            return_tensors="pt",
        )

        # 2. Move os tensores de entrada e a máscara de atenção para o dispositivo configurado (GPU ou CPU)
        input_ids = encoded_text["input_ids"].to(self.device)
        attention_mask = encoded_text["attention_mask"].to(self.device)

        # 3. Desativa o cálculo de gradientes para tornar a inferência mais eficiente
        with torch.no_grad():
            # 1. Passa os tensores pelo modelo e aplica a função softmax para obter probabilidades
            probabilities = F.softmax(self.classifier(input_ids, attention_mask), dim=1)

            # 2. Obtém a classe com a maior probabilidade (argmax) e a confiança dessa previsão
            confidence, predicted_class = torch.max(probabilities, dim=1)

            # 2. Converte os resultados de volta para a CPU e obtém valores numéricos
            predicted_class = predicted_class.cpu().item()  # Índice da classe prevista
            probabilities = (
                probabilities.flatten().cpu().numpy().tolist()
            )  # Probabilidades de todas as classes

            # 3. Retorna o nome da classe prevista, a confiança da previsão e um dicionário com as probabilidades de todas as classes
            return (
                predicted_class,  # Índice da classe prevista (0, 1, 2, 3, 4)
                config["CLASS_NAMES"][predicted_class], # Nome do sentimento previsto (Extremamente Negativo, Negativo, Neutro, Positivo, Extremamente Positivo)
                confidence.item(),  # Valor da confiança (ex.: 0.95)
                dict(zip(config["CLASS_NAMES"], probabilities)), # Dicionário com probabilidades de todas as classes
            )


"""
Instancia a classe Model para criar um objeto do modelo treinado
Vamos usar o padrão singleton para fazer isso apenas uma vez
"""
model = Model()


def get_model():
    return model
