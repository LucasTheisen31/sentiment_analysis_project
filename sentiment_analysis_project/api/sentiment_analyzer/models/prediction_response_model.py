from pydantic import BaseModel
from typing import List
from .class_probability_model import ClassProbabilityModel


class PredictionResponseModel(BaseModel):
    """
    Define a estrutura da resposta da previsão que será retornada pela API.
    """
    predicted_class: int  # O índice da classe prevista (0, 1, 2, 3, 4)
    predicted_sentiment: str  # O sentimento previsto (ex.: "positivo", "negativo")
    confidence: float  # A confiança da previsão (um valor numérico)
    probabilities: List[ClassProbabilityModel]
