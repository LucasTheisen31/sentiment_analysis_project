from pydantic import BaseModel


class ClassProbabilityModel(BaseModel):
    """
    Representa a probabilidade de um sentimento específico.
    """
    sentiment: str  # O sentimento previsto (ex.: "positivo", "negativo")
    sentiment_class: int  # A classe do sentimento (0, 1, 2, 3, 4)
    probability: float  # A probabilidade associada a esse sentimento (um valor numérico entre 0 e 1)
