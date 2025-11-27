# define a classe SentimentClassifier que é uma rede neural personalizada para classificação
# de sentimentos usando o modelo BERT da biblioteca transformers da Hugging Face
import json  # Importa o módulo para manipulação de arquivos JSON.

# Importa o módulo 'nn' do PyTorch para definir e treinar redes neurais.
from torch import nn

# Importa a classe 'AutoModel' da biblioteca 'transformers', que permite carregar e usar o modelo BERT.
from transformers import AutoModel

# Abre o arquivo 'config.json' e carrega seu conteúdo como um dicionário Python.
# Carrega a configuração que contém detalhes como o nome do modelo BERT.
with open("config.json") as json_file:
    config = json.load(json_file)


# Definindo o Classificador de Sentimento (BERT + Dropout + Camada Final) para Classificação.
class SentimentClassifier(nn.Module):
    def __init__(
        self, n_classes
    ):  # O construtor recebe o número de classes de saída para a classificação, como argumento.
        super(
            SentimentClassifier, self
        ).__init__()  # Inicializa a classe base 'nn.Module'.

        # Inicializa o modelo BERT pré-treinado.
        # O BERT será responsável por gerar as representações contextuais dos textos de entrada.
        # O `return_dict=False` significa que o retorno será uma tupla e não um dicionário.
        self.bert = AutoModel.from_pretrained(config["BASE_MODEL"], return_dict=False)

        # Camada de Dropout para regularização durante o treinamento.
        # Dropout é uma técnica que desativa aleatoriamente algumas conexões entre neurônios,
        # ajudando a evitar overfitting.
        self.drop = nn.Dropout(p=0.3)

        # Camada final totalmente conectada (linear), que mapeia o vetor de saída do BERT para a quantidade de classes de saída.
        # O número de features de entrada (in_features) é o tamanho da saída do BERT (geralmente 768).
        # O número de classes (out_features) é especificado pelo parâmetro `n_classes`, que no caso é 5 para sentimentos.
        self.out = nn.Linear(
            in_features=self.bert.config.hidden_size, out_features=n_classes
        )

    def forward(self, input_ids, attention_mask):
        # O método forward define o que acontece quando o modelo recebe dados de entrada.
        # O modelo BERT gera uma tupla com duas saídas: sequence_output e pooled_output.
        # A variável 'pooled_output' é a saída do token [CLS], que será usada para classificação.
        # `input_ids`: ids dos tokens que representam o texto.
        # `attention_mask`: mascara que indica quais tokens devem ser atendidos (ignora padding).

        # `pooled_output` é a representação do token [CLS], que é utilizado para tarefas de classificação.
        _, pooled_output = self.bert(
            input_ids=input_ids,  # IDs dos tokens de entrada
            attention_mask=attention_mask,  # Máscara de atenção para ignorar tokens de padding
        )

        # Aplica o Dropout sobre o pooled_output para regularização.
        # Durante o treinamento, algumas conexões são "desligadas" para evitar overfitting.
        output = self.drop(pooled_output)

        # A saída do Dropout é passada pela camada totalmente conectada (linear) para gerar as previsões de classe.
        # Aqui, `self.out(output)` retorna os logits para cada classe (por exemplo, positivo, neutro, negativo).
        return self.out(output)
