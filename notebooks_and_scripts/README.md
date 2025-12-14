# 📊 Scripts e Notebooks - Pipeline de Dados e Treinamento

## 👥 Autoria

**Autor:** Lucas Evandro Theisen  
**Orientador:** Prof. Dr. Anderson Brilhador  
**Coorientador:** Prof. Dr. Giuvane Conti

**Instituição:** Universidade Tecnológica Federal do Paraná - Campus Santa Helena  
**Curso:** Bacharelado em Ciência da Computação  
**Ano:** 2025

### Banca Examinadora

- Prof. Dr. Anderson Brilhador (Orientador) - UTFPR
- Profa. Dra. Giani Carla Ito - UTFPR
- Profa. Dra. Leliane Rezende - UTFPR

**Data de Aprovação:** 1 de dezembro de 2025

---

## 📄 Licença

<div align="center">

![CC BY-NC-SA](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)

**Creative Commons Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional**

</div>

© 2025 Lucas Evandro Theisen

Esta licença permite que reutilizadores distribuam, remixem, adaptem e criem a partir do material em qualquer meio ou formato apenas para fins não comerciais. Se outros modificarem ou adaptarem o material, eles devem licenciar o material modificado sob termos idênticos.

### 📋 Termos da Licença

**BY:** O crédito deve ser dado a você, o criador.

**NC:** Apenas o uso não comercial do seu trabalho é permitido. *Não comercial significa não primariamente direcionado para ou dirigido para vantagem comercial ou compensação monetária.*

**SA:** Adaptações devem ser compartilhadas sob os mesmos termos.

---

Veja o arquivo [LICENSE](../LICENSE) para o texto legal completo da licença.

---

---

## 📁 Estrutura dos Scripts

Esta pasta contém todos os scripts e notebooks utilizados no desenvolvimento do modelo de análise de sentimentos, organizados por etapa do pipeline:

```
notebooks_and_scripts/
│
├── 01_collection/             # Coleta de dados
│   └── data_collection.ipynb
│
├── 02_reannotation/           # Reannotação com Gemini
│   └── reannotation_gemini_2.5_pro.ipynb
│
├── 03_cleaning/               # Limpeza e pré-processamento
│   ├── data_cleaning.ipynb
│   ├── data_cleaning_and_filtering_leia.ipynb
│   ├── data_splitting.ipynb
│   └── reviews_3000.csv
│
├── 04_training/               # Treinamento do modelo
│   └── treinamento.ipynb
│
├── 05_results/                # Resultados e modelos salvos
│   ├── BERTimbau/
│   │   ├── Base/              # BERTimbau Base (109M parâmetros)
│   │   └── Large/             # BERTimbau Large (335M parâmetros)
│   ├── BERT multilingual/
│   │   └── Base/              # BERT Multilingual Base
│   └── XLMRoberta/
│       └── Base/              # XLM-RoBERTa Base
│
└── requirements.txt           # Dependências do projeto
```

---

## 🔄 Pipeline Completo

### 1️⃣ Coleta de Dados (`01_collection/`)

**Objetivo:** Coletar avaliações e comentários em português de aplicativos da Google Play Store.

**Notebook disponível:**

- [data_collection.ipynb](01_collection/data_collection.ipynb): Coleta de reviews usando `google-play-scraper`

**Funcionalidades implementadas:**

- Extração de informações de aplicativos (título, desenvolvedor, categoria, etc.)
- Coleta de reviews de múltiplos apps simultaneamente
- Filtragem por notas (1-5 estrelas)
- Diferentes critérios de ordenação:
  - `Sort.MOST_RELEVANT`: Reviews mais relevantes
  - `Sort.NEWEST`: Reviews mais recentes
- Controle de quantidade de reviews por app
- Exportação automática para CSV
- Identificação do app de origem (`app_id`) em cada review

**Dados coletados por review:**

- `reviewId`: ID único do comentário
- `userName`: Nome do usuário
- `userImage`: URL da imagem do perfil
- `content`: Texto do comentário
- `score`: Nota (1-5 estrelas)
- `thumbsUpCount`: Curtidas no comentário
- `reviewCreatedVersion`: Versão do app no momento da avaliação
- `at`: Data e hora da avaliação
- `replyContent`: Resposta do desenvolvedor (se houver)
- `repliedAt`: Data da resposta
- `app_id`: Identificador do aplicativo

**Saída:** Dataset bruto `1_dataset_original.csv` com textos e notas originais da Google Play Store

---

### 2️⃣ Reannotação com Gemini (`02_reannotation/`)

**Objetivo:** Refinar e validar as anotações dos dados usando a API Gemini 2.5 Pro.

**Notebook disponível:**

- [reannotation_gemini_2.5_pro.ipynb](02_reannotation/reannotation_gemini_2.5_pro.ipynb): Reannotação automática usando Gemini 2.5 Pro

**Por que reanotação?**

As notas da Google Play Store podem conter inconsistências onde o texto do comentário não corresponde à nota atribuída pelo usuário. A reannotação utiliza IA para:

- Identificar inconsistências entre texto e nota
- Corrigir classificações baseando-se no conteúdo textual
- Melhorar a qualidade dos dados de treinamento
- Reduzir ruído no dataset

**Funcionalidades implementadas:**

- Integração com Google Gemini API (`google-genai`)
- Prompt engineering detalhado para classificação 1-5 estrelas
- Modo "thinking" do Gemini para raciocínio aprofundado
- Análise contextual de sentimento do texto
- Sistema de validação e tratamento de erros
- Controle de rate limiting e timeouts
- Salvamento incremental (checkpoints)
- Coluna adicional no dataset: `score_reanotado_gemini`

**Configuração do modelo:**

```python
model = "gemini-2.0-flash-thinking-exp-01-21"
temperature = 0.1  # Baixa temperatura para maior consistência
```

**Prompt utilizado:**

O notebook utiliza um prompt estruturado que:

- Analisa o sentimento do texto
- Considera contexto cultural brasileiro
- Avalia emojis e expressões coloquiais
- Classifica em escala 1-5 (muito negativo → muito positivo)

**Saída:** Dataset reannotado `2_dataset_reanotado_gpt.csv` ou `3_dataset_reanotado_gemini_2_5_pro.csv` com labels refinados pela IA

---

### 3️⃣ Limpeza de Dados (`03_cleaning/`)

**Objetivo:** Preprocessar, limpar e preparar os dados para treinamento.

**Notebooks disponíveis:**

#### 📄 [data_cleaning.ipynb](03_cleaning/data_cleaning.ipynb)

**Limpeza básica com demojize**

**Funcionalidades:**

- Conversão de emojis para texto descritivo usando `emoji.demojize()`
  - Exemplo: 😊 → `:smiling_face_with_smiling_eyes:`
- Remoção de espaços duplicados
- Normalização de caracteres especiais
- Remoção de linhas duplicadas
- Tratamento de valores nulos

**Vantagem:** Preserva a informação semântica dos emojis em formato textual

---

#### 📄 [data_cleaning_and_filtering_leia.ipynb](03_cleaning/data_cleaning_and_filtering_leia.ipynb)

**Limpeza + Filtragem de Incoerências com LeIA**

**Funcionalidades adicionais:**

- Todas as funcionalidades do `data_cleaning.ipynb`
- **Filtragem inteligente usando LeIA (Lexicon-based Sentiment Analysis)**
  - Análise de sentimento do texto usando léxico em português
  - Detecção de incoerências entre score e sentimento textual
  - Remoção de exemplos conflitantes que podem prejudicar o treinamento
  - Threshold configurável para nível de filtragem (padrão: 0.5)

**Processo de filtragem:**

1. LeIA analisa o sentimento do texto (score de -1 a +1)
2. Compara com a nota atribuída (1-5 estrelas)
3. Remove exemplos onde há conflito significativo
4. Mantém apenas dados consistentes

**Vantagem:** Dataset mais limpo e consistente, reduzindo ruído no treinamento

---

#### 📄 [data_splitting.ipynb](03_cleaning/data_splitting.ipynb)

**Divisão dos Dados (Opcional)**

**Funcionalidades:**

- Separação em conjuntos de treino/validação/teste
- Estratificação por classe (mantém proporção de sentimentos)
- Seed fixa para reprodutibilidade
- Exportação para arquivos separados

**Proporções típicas:**

- Treino: 70% ou 80%
- Validação: 10% ou 15%
- Teste: 10% ou 20%

**Nota:** A divisão também pode ser feita diretamente no notebook de treinamento

---

**Arquivos gerados:**

- Pasta `datasets/Demojize/`: Datasets limpos com emojis convertidos
- Pasta `datasets/Leia + demojize/`: Datasets filtrados por LeIA
- Pasta `datasets/Divididos/`: Splits de treino/validação/teste
- `reviews_3000.csv`: Dataset de exemplo com 3000 reviews

**Saída principal:** Dataset limpo e preparado para treinamento, com ou sem filtragem de incoerências

---

### 4️⃣ Treinamento (`04_training/`)

**Objetivo:** Treinar e avaliar modelos transformers para análise de sentimentos.

**Notebook disponível:**

#### 📄 [treinamento.ipynb](04_training/treinamento.ipynb)

**Notebook completo de treinamento e avaliação**

**Modelos suportados:**

1. **BERTimbau Base** (109M parâmetros) - `neuralmind/bert-base-portuguese-cased`
2. **BERTimbau Large** (335M parâmetros) - `neuralmind/bert-large-portuguese-cased`
3. **BERT Multilingual Base** - `bert-base-multilingual-cased`
4. **XLM-RoBERTa Base** - `xlm-roberta-base`

**Pipeline de treinamento:**

1. **Carregamento de dados**
   - Leitura do dataset limpo
   - Verificação de qualidade dos dados
   - Análise exploratória inicial

2. **Tokenização**
   - Uso do tokenizer do modelo pré-treinado
   - Padding para tamanho máximo (MAX_LEN=128 ou 256)
   - Criação de attention masks
   - Conversão para tensores PyTorch

3. **Criação de DataLoaders**
   - Batching dos dados
   - Shuffling do conjunto de treino
   - Otimização para GPU/CPU

4. **Definição da arquitetura**
   - Carregamento do modelo pré-treinado
   - Camada de classificação customizada
   - Dropout para regularização
   - Fine-tuning de todas as camadas

5. **Configuração do treinamento**
   - Otimizador: AdamW
   - Learning rate scheduler: Linear com warmup
   - Loss function: CrossEntropyLoss (com ou sem class weights)
   - Métricas: Accuracy, F1-Score (macro), Precision, Recall

6. **Loop de treinamento**
   - Treinamento por epochs
   - Validação a cada epoch
   - Early stopping (opcional)
   - Salvamento do melhor modelo
   - Logging de métricas

7. **Avaliação final**
   - Teste no conjunto de teste
   - Matriz de confusão
   - Relatório de classificação
   - Análise de erros

**Hiperparâmetros típicos:**

```python
# Configurações comuns
MAX_LEN = 128           # Comprimento máximo de tokens
BATCH_SIZE = 4, 8, 16   # Tamanho do batch (varia por modelo/GPU)
EPOCHS = 10             # Número de épocas
TEST_SIZE = 0.3         # 30% para validação+teste

# Otimização
LEARNING_RATE = 2e-5, 3e-5, 5e-5  # Learning rates testados
WEIGHT_DECAY = 0.01     # Regularização L2
DROPOUT = 0.3           # Dropout na camada de classificação
WARMUP_STEPS = 10%      # Warmup do learning rate

# Class balancing
CLASS_WEIGHTS = None    # Ou 'balanced' para desbalanceamento
```

**Experimentos realizados:**

O notebook suporta múltiplas configurações experimentais:

- 3 datasets diferentes (Original, Reannotado GPT, Reannotado Gemini)
- 3 learning rates (2e-5, 3e-5, 5e-5)
- 2-3 batch sizes (4, 8, 16)
- Com/sem class weights
- Com/sem demojize
- Com/sem filtragem LeIA
- Diferentes splits de validação/teste

**Técnicas de otimização:**

- **Gradient accumulation**: Para simular batch sizes maiores
- **Mixed precision training**: Para economia de memória (opcional)
- **Learning rate warmup**: Estabiliza o início do treinamento
- **Weight decay**: Regularização para evitar overfitting
- **Class weights**: Balanceamento de classes desbalanceadas

**Saída:** Modelo treinado (`.pt`), histórico de treinamento, métricas de avaliação

---

### 5️⃣ Resultados Salvos (`05_results/`)

**Objetivo:** Armazenar modelos treinados, métricas e resultados de experimentos extensivos.

**Estrutura de pastas:**

```
05_results/
├── BERTimbau/
│   ├── Base/          # 90+ experimentos com BERTimbau Base
│   │   ├── DTOriginal - 3000 - EPOCHS=10 - TEST_SIZE=0.3 - BATCH_S=4 - LR=2e-5/
│   │   ├── DTOriginal - 3000 - ... - ClassW=balanced - Demojize/
│   │   ├── DTOriginal - 3000 - ... - ClassW=balanced - Demojize - Leia0.5/
│   │   ├── DTReanotadoGPT - 3000 - EPOCHS=10 - TEST_SIZE=0.3 - BATCH_S=4 - LR=3e-5/
│   │   ├── DTReanotadoGemini-2.5-pro - 3000 - EPOCHS=10 - ... /
│   │   └── ... (múltiplas configurações)
│   └── Large/         # 36+ experimentos com BERTimbau Large
│       ├── DTOriginal - 3000 - EPOCHS=10 - TEST_SIZE=0.3 - BATCH_S=4 - LR=2e-5/
│       ├── DTReanotadoGPT - 3000 - ... /
│       └── ... (múltiplas configurações)
│
├── BERT multilingual/
│   └── Base/          # Experimentos com BERT Multilingual
│
└── XLMRoberta/
    └── Base/          # Experimentos com XLM-RoBERTa
```

**Conteúdo de cada pasta de experimento:**

Cada pasta de experimento contém:

- `model.pt`: Modelo treinado (state dict do PyTorch)
- `training_history.csv`: Histórico de loss e métricas por epoch
- `metrics.json`: Métricas finais (accuracy, F1, precision, recall)
- `confusion_matrix.png`: Matriz de confusão visualizada
- `classification_report.txt`: Relatório detalhado por classe
- `training_curves.png`: Gráficos de loss e accuracy
- `config.json`: Configuração de hiperparâmetros usada

**Nomenclatura dos experimentos:**

Os experimentos seguem um padrão descritivo:

- `DTOriginal`: Dataset original da Google Play Store
- `DTReanotadoGPT`: Dataset reannotado com GPT
- `DTReanotadoGemini-2.5-pro`: Dataset reannotado com Gemini 2.5 Pro
- `3000`: Número de exemplos no dataset
- `EPOCHS=10`: Número de épocas de treinamento
- `TEST_SIZE=0.3`: Proporção de dados para validação+teste
- `BATCH_S=4`: Tamanho do batch
- `LR=2e-5`: Learning rate
- `ClassW=balanced`: Uso de class weights balanceados
- `Demojize`: Emojis convertidos para texto
- `Leia0.5`: Filtragem LeIA com threshold 0.5
- `TestVal=Orig`: Validação/teste com dataset original

**Comparação de modelos:**

Total de experimentos realizados:

- **BERTimbau Base**: ~90 experimentos
- **BERTimbau Large**: ~36 experimentos
- **BERT Multilingual**: Múltiplos experimentos
- **XLM-RoBERTa**: Múltiplos experimentos

**Grid search realizado:**

- 3 modelos base (BERTimbau Base/Large, BERT Multilingual)
- 3 datasets (Original, GPT, Gemini)
- 3 learning rates (2e-5, 3e-5, 5e-5)
- 2-3 batch sizes (4, 8, 16)
- 2 configurações de weights (None, balanced)
- 2 configurações de limpeza (original, demojize)
- 2-3 configurações de filtragem (nenhuma, LeIA 0.5, cross-validation)

**Total**: Mais de 200 experimentos realizados para encontrar a melhor configuração

---

## 🚀 Como Usar

### Requisitos

```bash
pip install -r requirements.txt
```

**Principais bibliotecas:**

- google-play-scraper (coleta de dados)
- google-genai, google-generativeai (reannotação com Gemini)
- emoji, leia-br (processamento de texto e filtragem)
- pandas, numpy (manipulação de dados)
- matplotlib, seaborn (visualizações)
- scikit-learn (métricas e divisão de dados)
- torch, transformers (deep learning)
- jupyter, ipykernel (notebooks)

### Executar Pipeline Completo

```bash
# 0. Instalar dependências
pip install -r requirements.txt

# 1. Coletar dados da Google Play Store
jupyter notebook 01_collection/data_collection.ipynb
# Saída: datasets/1_dataset_original.csv

# 2. Reannotar com Gemini (opcional, mas altamente recomendado)
jupyter notebook 02_reannotation/reannotation_gemini_2.5_pro.ipynb
# Saída: datasets/3_dataset_reanotado_gemini_2_5_pro.csv

# 3. Limpar e preparar dados
# Escolha uma das opções abaixo:

# Opção A: Limpeza básica (apenas demojize)
jupyter notebook 03_cleaning/data_cleaning.ipynb
# Saída: datasets/Demojize/[dataset]_limpeza_demojize.csv

# Opção B: Limpeza + filtragem de incoerências (RECOMENDADO)
jupyter notebook 03_cleaning/data_cleaning_and_filtering_leia.ipynb
# Saída: datasets/Leia + demojize/filtrados/[dataset]_limpeza_demojize_leia.csv

# Opção C: Dividir dados (opcional, pode ser feito no treinamento)
jupyter notebook 03_cleaning/data_splitting.ipynb
# Saída: datasets/Divididos/train.csv, val.csv, test.csv

# 4. Treinar modelo
jupyter notebook 04_training/treinamento.ipynb
# Saída: 05_results/[Modelo]/[Config]/model.pt + métricas

# 5. Analisar resultados
# Verifique os arquivos gerados em 05_results/
```

### Pipeline Recomendado (Melhor Qualidade)

Para obter os melhores resultados baseados nos experimentos realizados:

```bash
# 1. Coleta de dados
jupyter notebook 01_collection/data_collection.ipynb

# 2. Reannotação com Gemini (melhora consistência)
jupyter notebook 02_reannotation/reannotation_gemini_2.5_pro.ipynb

# 3. Limpeza + Filtragem LeIA (remove incoerências)
jupyter notebook 03_cleaning/data_cleaning_and_filtering_leia.ipynb

# 4. Treinamento com BERTimbau Base
# Configure no notebook:
# - DATASET: dataset reannotado e filtrado
# - MODEL: BERTimbau Base
# - LEARNING_RATE: 3e-5
# - BATCH_SIZE: 8 ou 16
# - CLASS_WEIGHTS: 'balanced' (se classes desbalanceadas)
jupyter notebook 04_training/treinamento.ipynb
```

---

## 📊 Datasets Utilizados

### Datasets Principais

Os datasets estão localizados na pasta `../datasets/`:

1. **[1_dataset_original.csv](../datasets/1_dataset_original.csv)**
   - Dataset bruto coletado da Google Play Store
   - ~3000+ reviews de aplicativos brasileiros
   - Colunas principais: `content` (texto), `score` (1-5)

2. **[2_dataset_reanotado_gpt.csv](../datasets/2_dataset_reanotado_gpt.csv)**
   - Dataset reannotado usando GPT
   - Coluna adicional: `score_reanotado_gpt`
   - Melhora consistência entre texto e sentimento

3. **[3_dataset_reanotado_gemini_2_5_pro.csv](../datasets/3_dataset_reanotado_gemini_2_5_pro.csv)**
   - Dataset reannotado usando Gemini 2.5 Pro
   - Coluna adicional: `score_reanotado_gemini`
   - Análise contextual mais profunda

### Datasets Processados

Localizados nas subpastas:

- **`Demojize/`**: Datasets com emojis convertidos para texto
- **`Leia + demojize/filtrados/`**: Datasets filtrados por incoerências (LeIA)
- **`Divididos/`**: Datasets já divididos em treino/validação/teste

### Características do Dataset

- **Tamanho:** ~3000 exemplos (varia após filtragem)
- **Idioma:** Português brasileiro
- **Domínio:** Reviews de aplicativos móveis (Google Play Store)
- **Classes:** 5 (1-5 estrelas)
  - 1 ⭐: Muito negativo
  - 2 ⭐: Negativo
  - 3 ⭐: Neutro
  - 4 ⭐: Positivo
  - 5 ⭐: Muito positivo

### Divisão Típica dos Dados

- **Treino:** 70% (2100 exemplos)
- **Validação:** 15% (450 exemplos)
- **Teste:** 15% (450 exemplos)

*Nota: Os valores exatos variam dependendo do dataset e filtragem aplicada*

### Fontes de Dados

- Google Play Store (via `google-play-scraper`)
- Aplicativos brasileiros de diversas categorias
- Período de coleta: 2024-2025

---

## 📈 Resultados do Treinamento

### Configuração Recomendada

Baseado em mais de 200 experimentos realizados:

```python
# Dataset
DATASET = "3_dataset_reanotado_gemini_2_5_pro"  # Reannotado com Gemini
CLEANING = "Demojize"                           # Emojis convertidos
FILTERING = "Leia0.5"                           # Filtrado por LeIA (threshold 0.5)

# Modelo
MODEL = "neuralmind/bert-base-portuguese-cased"  # BERTimbau Base
MAX_LEN = 128                                     # Comprimento máximo de tokens

# Hiperparâmetros
LEARNING_RATE = 3e-5      # Melhor performance nos experimentos
BATCH_SIZE = 8            # Balanceamento entre velocidade e memória
EPOCHS = 10               # Convergência típica entre 7-10 epochs
DROPOUT = 0.3             # Regularização
WEIGHT_DECAY = 0.01       # Regularização L2
WARMUP_STEPS = 10%        # Warmup do learning rate

# Balanceamento
CLASS_WEIGHTS = "balanced"  # Recomendado se classes desbalanceadas

# Otimizador
OPTIMIZER = "AdamW"
SCHEDULER = "linear_with_warmup"
```

### Resultados Típicos (BERTimbau Base)

Os resultados variam conforme o dataset e configuração. Exemplos típicos:

| Configuração | Accuracy | F1-Score (macro) | Observações |
|--------------|----------|------------------|-------------|
| Original + Demojize | 55-65% | 0.45-0.55 | Baseline, presença de ruído |
| Reannotado GPT + Demojize | 60-70% | 0.50-0.60 | Melhora na consistência |
| Reannotado Gemini + Demojize + LeIA | 65-75% | 0.55-0.65 | **Melhor performance** |
| BERTimbau Large (melhor config) | 70-78% | 0.60-0.68 | Mais parâmetros, mais lento |

*Nota: Valores exatos disponíveis nas pastas individuais em `05_results/`*

### Insights dos Experimentos

**1. Impacto da reannotação:**

- Reannotação com Gemini 2.5 Pro melhorou consistência em ~5-10%
- GPT também efetivo, mas Gemini teve melhor compreensão de contexto brasileiro

**2. Impacto da filtragem LeIA:**

- Remoção de incoerências melhorou F1-score em ~3-7%
- Dataset menor mas mais limpo = melhor generalização

**3. Learning rate:**

- 2e-5: Convergência mais lenta, mais estável
- **3e-5: Melhor balanço** (recomendado)
- 5e-5: Convergência rápida, risco de overfitting

**4. Batch size:**

- Batch 4: Mais lento, memória limitada
- **Batch 8: Melhor balanço** (recomendado)
- Batch 16: Mais rápido, requer mais memória GPU

**5. Class weights:**

- Essencial quando classes estão desbalanceadas (>2:1 ratio)
- Melhora recall de classes minoritárias

**6. Modelo:**

- BERTimbau Base: Melhor custo-benefício
- BERTimbau Large: +5-8% accuracy, 3x mais lento
- BERT Multilingual: Performance inferior para português
- XLM-RoBERTa: Comparable ao BERTimbau Base

---

## 🔧 Reprodutibilidade

### Seeds Utilizadas

Para garantir reprodutibilidade, as seguintes seeds foram fixadas em todos os notebooks:

```python
SEED = 42  # Seed padrão usado em todos os experimentos

# Python random
import random
random.seed(SEED)

# NumPy
import numpy as np
np.random.seed(SEED)

# PyTorch
import torch
torch.manual_seed(SEED)
torch.cuda.manual_seed(SEED)
torch.cuda.manual_seed_all(SEED)

# Configurações adicionais para reprodutibilidade
torch.backends.cudnn.deterministic = True
torch.backends.cudnn.benchmark = False
```

### Ambiente e Requisitos

**Python:** 3.9+ (testado em 3.9, 3.10, 3.11)

**Principais dependências:**

```txt
# Deep Learning
torch==2.1.2+cpu           # PyTorch (CPU version)
torchvision==0.16.2+cpu
torchaudio==2.1.2+cpu
transformers==4.36.2       # Hugging Face Transformers

# Data Science
pandas==2.1.4
numpy==1.26.4
matplotlib==3.8.2
seaborn==0.13.0
scikit-learn==1.3.2

# Text Processing
emoji==2.10.0              # Conversão de emojis
leia-br==0.0.1             # Análise de sentimento em português

# APIs
google-play-scraper==1.2.7  # Coleta de dados
google-genai==0.2.2         # Reannotação com Gemini
google-generativeai==0.8.3

# Jupyter
jupyter==1.0.0
ipykernel==6.27.1
notebook==7.0.6

# Utilities
tqdm==4.66.1               # Barras de progresso
watermark==2.4.3           # Versionamento
```

## 📚 Documentação Adicional

### Documentos do Projeto

| Documento | Descrição |
|-----------|-----------|
| [README.txt](../README.txt) | Instruções de uso do sistema completo |
| [README.md](../README.md) | Visão geral do projeto |
| [api/README.md](../sentiment_analysis_project/api/README.md) | Documentação técnica da API |
| [api/TRAINING.md](../sentiment_analysis_project/api/TRAINING.md) | Explicação visual dos conceitos de treinamento |
| [LICENSE](../LICENSE) | Licença do projeto |

---

## 📄 Citação Acadêmica

Se você utilizar este trabalho em sua pesquisa, por favor cite:

```bibtex
@mastersthesis{theisen2025sentiment,
  title={Análise de Sentimentos em Comentários de Aplicativos Comerciais},
  author={Theisen, Lucas Evandro},
  year={2025},
  school={Universidade Tecnológica Federal do Paraná},
  type={Trabalho de Conclusão de Curso},
  address={Santa Helena, PR, Brasil}
}
```

**Nota:** Esta documentação faz parte do TCC "ANÁLISE DE SENTIMENTOS EM COMENTÁRIOS DE APLICATIVOS COMERCIAIS", desenvolvido na UTFPR - Campus Santa Helena em 2025.
