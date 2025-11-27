
from fastapi import Depends, FastAPI # O Depends permite a injeção de dependências em rotas, como injetar o modelo treinado automaticamente. FastAPI cria a aplicação.
from fastapi.middleware.cors import CORSMiddleware # Importa o middleware de CORS para permitir o compartilhamento de recursos entre diferentes origens (domínios)

# Importa o modelo de classificação de sentimentos (Model) e a função (get_model) que fornece uma instância dele. get_model é usado para obter o modelo carregado e já em modo de inferência.
from .classifier.model import Model, get_model
# Importa os models Pydantic para validação de dados
from .models.prediction_request_model import PredictionRequestModel
from .models.class_probability_model import ClassProbabilityModel
from .models.prediction_response_model import PredictionResponseModel 

# Cria uma instância da aplicação FastAPI
app = FastAPI()

# Define uma lista de origens permitidas para acessar a API. O "*" permite qualquer origem (menos seguro em produção)
origins = ["*"]

# Adiciona o middleware CORS para que a API possa ser acessada de diferentes domínios
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # Lista de origens permitidas
    allow_credentials=True,  # Permite o envio de credenciais (cookies, cabeçalhos HTTP de autenticação)
    allow_methods=["*"],  # Permite todos os métodos HTTP (GET, POST, etc.)
    allow_headers=["*"],  # Permite todos os cabeçalhos HTTP
)

# Cria um endpoint POST na rota "/predict" que retorna uma resposta no formato PredictionResponseModel
@app.post("/predict", response_model=PredictionResponseModel)
def predict(request: PredictionRequestModel, model: Model = Depends(get_model)):
    """
    Função que recebe uma solicitação com o texto e retorna a previsão de sentimento.
    A injeção de dependência do modelo é feita através da função 'get_model', que carrega
    o modelo de classificação treinado.
    """

    # Realiza a previsão usando o texto recebido na solicitação
    predicted_class, predicted_sentiment, confidence, prob_dict = model.predict(request.text)

    # Cria a lista de probabilidades para cada classe (0, 1, 2, 3, 4) usando o dicionário retornado pelo modelo
    probabilities = [
        ClassProbabilityModel(
            sentiment=sentiment,
            probability=probability,
            sentiment_class=i  # índice da classe
        )
        for i, (sentiment, probability) in enumerate(prob_dict.items())
    ]

    # Retorna a resposta estruturada com as probabilidades, o sentimento previsto e a confiança
    return PredictionResponseModel(
        predicted_class=predicted_class,
        predicted_sentiment=predicted_sentiment,
        confidence=confidence,
        probabilities=probabilities
    )

#http POST http://127.0.0.1:8000/predict text="Test"
#bin/start_server