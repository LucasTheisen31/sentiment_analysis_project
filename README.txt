================================================================================
  SISTEMA DE ANÁLISE DE SENTIMENTOS - TRABALHO DE CONCLUSÃO DE CURSO
================================================================================


TÍTULO: ANÁLISE DE SENTIMENTOS EM COMENTÁRIOS DE APLICATIVOS COMERCIAIS


AUTOR: Lucas Evandro Theisen
ORIENTADOR: Prof. Dr. Anderson Brilhador
COORIENTADOR: Prof. Dr. Giuvane Conti

INSTITUIÇÃO: Universidade Tecnológica Federal do Paraná - Campus Santa Helena
CURSO: Bacharelado em Ciência da Computação
ANO: 2025

Banca Examinadora:
  - Prof. Dr. Anderson Brilhador (Orientador) - UTFPR
  - Profa. Dra. Giani Carla Ito - UTFPR
  - Profa. Dra. Leliane Rezende - UTFPR

Data de Aprovação: 1 de dezembro de 2025

PALAVRAS-CHAVE: análise de sentimentos; processamento de linguagem natural; 
transformers; BERT; aprendizado profundo

================================================================================
  DESCRIÇÃO DO SISTEMA
================================================================================

Sistema completo para análise automática de sentimentos em avaliações e 
comentários em português brasileiro. Utiliza modelo de Deep Learning baseado 
em BERT (BERTimbau) para classificar textos em 5 níveis de sentimento:

1. Extremamente Negativo
2. Negativo
3. Neutro
4. Positivo
5. Extremamente Positivo

COMPONENTES:
- API REST (Python/FastAPI): Servidor que hospeda o modelo de IA
- Aplicação Web (Flutter): Interface gráfica para usuários
- Docker Compose: Orquestração dos containers

================================================================================
  REQUISITOS DO SISTEMA
================================================================================

HARDWARE MÍNIMO:
- Processador: 2 núcleos, 2.0 GHz ou superior
- Memória RAM: 4 GB (8 GB recomendado)
- Espaço em disco: 5 GB livres
- GPU (opcional): NVIDIA com CUDA para melhor performance

SOFTWARE NECESSÁRIO:
- Docker Desktop 20.10+ ou Docker Engine + Docker Compose
- Sistema Operacional: Windows 10/11, Linux ou macOS

PORTAS UTILIZADAS:
- 8000: API (Backend)
- 8080: Web (Frontend)

================================================================================
  INSTRUÇÕES DE INSTALAÇÃO
================================================================================

PASSO 1: INSTALAR DOCKER
-------------------------
Windows/Mac: Baixe e instale o Docker Desktop em https://www.docker.com/
Linux: Execute os comandos:
  sudo apt-get update
  sudo apt-get install docker.io docker-compose

Verifique a instalação:
  docker --version
  docker-compose --version

PASSO 2: EXTRAIR OS ARQUIVOS
-----------------------------
Extraia o arquivo comprimido (.zip, .tar ou .xz) em um diretório de sua 
escolha. Exemplo:
  - Windows: C:\sentiment_analysis_project\
  - Linux/Mac: ~/sentiment_analysis_project/

PASSO 3: NAVEGAR ATÉ O DIRETÓRIO
---------------------------------
Abra o terminal (cmd, PowerShell ou bash) e navegue até o diretório:
  cd [caminho_onde_extraiu]/sentiment_analysis_project

================================================================================
  INSTRUÇÕES DE USO
================================================================================

INICIAR O SISTEMA:
------------------
Execute o comando no terminal:
  docker-compose up -d

Aguarde 1-2 minutos para os containers iniciarem completamente.

ACESSAR A APLICAÇÃO:
--------------------
1. Abra seu navegador (Chrome, Firefox, Edge, etc.)
2. Acesse: http://localhost:8080
3. A interface web será carregada

USAR A APLICAÇÃO:
-----------------
1. Digite ou cole um texto na área de entrada
2. O sistema analisará automaticamente após 700ms de pausa na digitação
3. Visualize o resultado:
   - Sentimento identificado (com emoji e estrelas)
   - Probabilidades de cada classe
   - Gráfico de confiança

VERIFICAR STATUS DA API:
------------------------
Acesse no navegador: http://localhost:8000
Você verá a mensagem: {"status": "online"}

DOCUMENTAÇÃO INTERATIVA DA API:
-------------------------------
Acesse: http://localhost:8000/docs
Interface Swagger com todos os endpoints disponíveis.

PARAR O SISTEMA:
----------------
Execute no terminal:
  docker-compose down

REINICIAR O SISTEMA:
--------------------
Execute no terminal:
  docker-compose restart

VISUALIZAR LOGS:
----------------
Para ver os logs da API:
  docker-compose logs api_service

Para ver os logs do frontend:
  docker-compose logs web_service

================================================================================
  ESTRUTURA DE ARQUIVOS
================================================================================

sentiment_analysis_project/
│
├── README.txt                    # Este arquivo (instruções)
├── README.md                     # Documentação completa (formato Markdown)
├── docker-compose.yml            # Orquestração dos containers
│
├── api/                          # Backend (API REST)
│   ├── Dockerfile               # Imagem Docker da API
│   ├── requirements.txt         # Dependências Python
│   ├── config.json              # Configurações do modelo
│   ├── README.md                # Documentação da API
│   ├── TRAINING.md              # Documentação do treinamento
│   ├── bin/
│   │   └── start_server.sh      # Script de inicialização
│   └── sentiment_analyzer/
│       ├── api.py               # Código principal da API
│       └── classifier/
│           └── model.py         # Código do modelo BERT
│
├── web/                          # Frontend (Aplicação Web)
│   ├── Dockerfile               # Imagem Docker do frontend
│   ├── index.html               # Página principal
│   ├── main.dart.js             # Aplicação Flutter compilada
│   └── nginx/
│       └── default.conf         # Configuração do servidor web
│
└── sentiment_analysis_app/       # Código fonte Flutter (desenvolvimento)
    ├── lib/
    │   ├── main.dart            # Ponto de entrada da aplicação
    │   ├── models/              # Modelos de dados
    │   ├── repositories/        # Comunicação com API
    │   └── screens/             # Telas da interface
    └── pubspec.yaml             # Dependências Flutter

================================================================================
  ENDPOINTS DA API
================================================================================

POST /predict
-------------
Analisa o sentimento de um texto.

Corpo da requisição (JSON):
{
  "text": "Este produto é excelente! Recomendo muito."
}

Resposta (JSON):
{
  "sentiment": "extremamente_positivo",
  "predicted_class": 4,
  "probabilities": {
    "extremamente_negativo": 0.01,
    "negativo": 0.02,
    "neutro": 0.05,
    "positivo": 0.15,
    "extremamente_positivo": 0.77
  }
}

GET /
-----
Verifica status da API.

Resposta: {"status": "online"}

GET /docs
---------
Documentação interativa (Swagger UI).

GET /redoc
----------
Documentação alternativa (ReDoc).

================================================================================
  SOLUÇÃO DE PROBLEMAS
================================================================================

PROBLEMA: "Porta 8000 ou 8080 já está em uso"
SOLUÇÃO: 
  1. Identifique o processo usando a porta:
     Windows: netstat -ano | findstr :8000
     Linux/Mac: lsof -i :8000
  2. Encerre o processo ou altere a porta no docker-compose.yml

PROBLEMA: "Docker não encontrado"
SOLUÇÃO: 
  1. Certifique-se de que o Docker está instalado
  2. Reinicie o terminal após a instalação
  3. No Windows, certifique-se de que o Docker Desktop está rodando

PROBLEMA: "Containers não iniciam"
SOLUÇÃO:
  1. Verifique os logs: docker-compose logs
  2. Certifique-se de que tem espaço em disco suficiente
  3. Tente reconstruir as imagens: docker-compose build --no-cache

PROBLEMA: "API retorna erro 500"
SOLUÇÃO:
  1. Verifique se o modelo foi baixado corretamente
  2. Verifique os logs da API: docker-compose logs api_service
  3. Certifique-se de que tem memória RAM suficiente

PROBLEMA: "Interface web não carrega"
SOLUÇÃO:
  1. Limpe o cache do navegador (Ctrl+Shift+Del)
  2. Tente outro navegador
  3. Verifique se o serviço web está rodando: docker-compose ps

================================================================================
  INFORMAÇÕES TÉCNICAS ADICIONAIS
================================================================================

MODELO DE IA:
- Base: BERTimbau (neuralmind/bert-base-portuguese-cased)
- Arquitetura: BERT + Dropout (0.3) + Camada Linear
- Parâmetros treináveis: ~110 milhões
- Fine-tuning: 10 épocas
- Otimizador: AdamW
- Learning Rate: 3e-5 com linear decay e warmup
- Weight Decay: 0.01

TECNOLOGIAS:
- Backend: Python 3.9+, FastAPI 0.95+, PyTorch, Transformers
- Frontend: Flutter 3.0+, MobX
- Infraestrutura: Docker, Docker Compose, Nginx
- Validação: Pydantic

PERFORMANCE:
- Tempo de resposta: < 500ms (CPU) / < 100ms (GPU)
- Throughput: Múltiplas requisições concorrentes
- Tamanho do modelo: ~1.3 GB

SEGURANÇA:
- CORS habilitado para localhost
- Validação automática de entrada
- Sanitização de texto
- Rate limiting recomendado para produção


================================================================================
  LICENÇA
================================================================================

Copyright © 2025 Lucas Evandro Theisen

Este trabalho está licenciado sob a Licença Creative Commons
Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional (CC BY-NC-SA 4.0).

Esta licença permite que reutilizadores distribuam, remixem, adaptem e criem a partir 
do material em qualquer meio ou formato apenas para fins não comerciais. Se outros 
modificarem ou adaptarem o material, eles devem licenciar o material modificado sob termos idênticos.

Termos principais:
  - BY: O crédito deve ser dado ao autor.
  - NC: Apenas o uso não comercial do trabalho é permitido.
    (Não comercial significa não primariamente direcionado para ou dirigido para vantagem 
    comercial ou compensação monetária.)
  - SA: Adaptações devem ser compartilhadas sob os mesmos termos.

Veja o arquivo LICENSE para o texto legal completo da licença.

================================================================================
  CITAÇÃO
================================================================================

@mastersthesis{theisen2025sentiment,
  title   = {Análise de Sentimentos em Comentários de Aplicativos Comerciais},
  author  = {Theisen, Lucas Evandro},
  year    = {2025},
  school  = {Universidade Tecnológica Federal do Paraná},
  type    = {Trabalho de Conclusão de Curso},
  address = {Santa Helena, PR, Brasil}
}

================================================================================
                            FIM DO DOCUMENTO
================================================================================
