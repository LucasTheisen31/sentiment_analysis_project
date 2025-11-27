from pydantic import BaseModel


class PredictionRequestModel(BaseModel):
    """
    Define a estrutura de dados esperada para a solicitação de previsão.
    Recebe uma string (text) que representa o texto sobre o qual queremos fazer a análise de sentimento.
    """
    text: str  # O texto de entrada que será analisado pelo modelo
