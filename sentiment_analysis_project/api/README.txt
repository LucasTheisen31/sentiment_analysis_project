================================================================================
SISTEMA DE ANÁLISE DE SENTIMENTOS - API DE CLASSIFICAÇÃO
================================================================================

INFORMAÇÕES DE AUTORIA
-----------------------

Autor: Lucas Evandro Theisen
Orientador: Dr. Anderson Brilhador
Coorientador: Dr. Giuvane Conti

Instituição: Universidade Tecnológica Federal do Paraná - Campus Santa Helena
Curso: Ciência da Computação
Ano: 2025

================================================================================
DESCRIÇÃO DO PRODUTO
================================================================================

Esta API REST foi desenvolvida como produto tecnológico do Trabalho de
Conclusão de Curso (TCC) intitulado "Análise de Sentimentos em Comentários de 
Aplicativos Comerciais".

A API fornece endpoints para classificação automática de sentimentos em 
comentários e avaliações em português brasileiro, utilizando modelos de Deep 
Learning baseados em arquiteturas Transformer.

FUNCIONALIDADES PRINCIPAIS:
- Endpoint POST /predict para classificação de sentimentos
- Retorno de probabilidades por classe (Positivo, Neutro, Negativo)
- Suporte a CORS para integração com aplicações web
- Processamento em tempo real
- Validação de dados com Pydantic

================================================================================
TECNOLOGIAS UTILIZADAS
================================================================================

Framework: FastAPI 0.95+
Linguagem: Python 3.9+
Deep Learning: PyTorch, Transformers (Hugging Face)

DEPENDÊNCIAS PRINCIPAIS:
- FastAPI: framework web moderno e rápido
- Uvicorn: servidor ASGI
- PyTorch: framework de Deep Learning
- Transformers: modelos pré-treinados (BERT, BERTimbau, XLM-RoBERTa)
- Pydantic: validação de dados

================================================================================
LICENCIAMENTO
================================================================================

Este produto possui duplo licenciamento:

1. CÓDIGO FONTE - MIT License
   Copyright (c) 2025 Lucas Evandro Theisen
   
   É concedida permissão, gratuitamente, para uso, cópia, modificação e 
   distribuição do software.

2. TRABALHO ACADÊMICO - Creative Commons Atribuição-NãoComercial-CompartilhaIgual
   4.0 Internacional (CC BY-NC-SA 4.0)
   https://creativecommons.org/licenses/by-nc-sa/4.0/
   
   Você tem o direito de:
   - Compartilhar: copiar e redistribuir o material
   - Adaptar: remixar, transformar e criar a partir do material
   
   Sob as condições de:
   - Atribuição: dar o crédito apropriado ao autor original
   - NãoComercial: não usar o material para fins comerciais
   - CompartilhaIgual: distribuir sob a mesma licença

================================================================================
CITAÇÃO ACADÊMICA
================================================================================

Para citar este trabalho em publicações acadêmicas:

THEISEN, Lucas Evandro. Análise de Sentimentos em Comentários de Aplicativos 
Comerciais. 2025. Trabalho de Conclusão de Curso – Ciência da Computação, 
Universidade Tecnológica Federal do Paraná, Santa Helena, 2025.

================================================================================
INSTRUÇÕES DE USO
================================================================================

REQUISITOS DO SISTEMA:
- Python 3.9 ou superior
- pip (gerenciador de pacotes Python)
- 4GB+ RAM (recomendado 8GB+)
- GPU com CUDA (opcional, mas recomendado)

INSTALAÇÃO:
1. Instale as dependências:
   pip install -r requirements.txt

2. Configure o arquivo config.json com o caminho do modelo:
   {
     "model_path": "caminho/para/modelo/treinado"
   }

3. Execute a API:
   uvicorn sentiment_analyzer.api:app --host 0.0.0.0 --port 8000

ENDPOINTS DISPONÍVEIS:
- POST /predict
  Body: {"text": "comentário para análise"}
  Response: {
    "sentiment": "positivo|neutro|negativo",
    "probabilities": [
      {"class": "positivo", "probability": 0.85},
      {"class": "neutro", "probability": 0.10},
      {"class": "negativo", "probability": 0.05}
    ]
  }

- GET /docs
  Documentação interativa da API (Swagger UI)

ESTRUTURA DE DIRETÓRIOS:
api/
  └── sentiment_analyzer/
      ├── api.py                    # Definição da API FastAPI
      ├── classifier/               # Módulos de classificação
      │   ├── model.py             # Gerenciamento do modelo
      │   └── sentiment_classifier.py
      └── models/                   # Modelos Pydantic
          ├── prediction_request_model.py
          ├── prediction_response_model.py
          └── class_probability_model.py

================================================================================
DOCKER
================================================================================

A API pode ser executada em container Docker:

1. Build da imagem:
   docker-compose build

2. Executar container:
   docker-compose up -d

3. Verificar logs:
   docker-compose logs -f

================================================================================
CONTATO E INFORMAÇÕES ADICIONAIS
================================================================================

Para mais informações sobre o projeto, consulte:
- README.md na raiz do repositório
- Documentação completa no trabalho de conclusão de curso
- Repositório do projeto: [adicione o link quando disponível]

Data de criação: 2025
Última atualização: Dezembro de 2025

================================================================================
