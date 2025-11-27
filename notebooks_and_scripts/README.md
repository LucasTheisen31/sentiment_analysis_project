# 📊 Scripts e Notebooks - Pipeline de Dados e Treinamento

> Documentação completa dos scripts utilizados para coleta, limpeza, análise e treinamento do modelo de análise de sentimentos.

---

## 👥 Autoria

**Autor:** Lucas Evandro Theisen  
**Orientador:** Dr. Anderson Brilhador  
**Coorientador:** Dr. Giuvane Conti

**Instituição:** Universidade Tecnológica Federal do Paraná - Campus Santa Helena  
**Curso:** Ciência da Computação  
**Ano:** 2025

---

## 📁 Estrutura dos Scripts

Esta pasta contém todos os scripts e notebooks utilizados no desenvolvimento do modelo de análise de sentimentos, organizados por etapa do pipeline:

```
notebooks_and_scripts/
│
├── 01_collection/             # Coleta de dados
│   └── extração_dos_dados.ipynb
│
├── 02_reannotation/           # Reannotação com Gemini
│   └── reannotation_gemini_2.5_pro.ipynb
│
├── 03_cleaning/               # Limpeza e pré-processamento
│   ├── data_cleaning.ipynb
│   ├── data_cleaning_and_filtering_leia.ipynb
│   └── data_splitting.ipynb
│
├── 04_analysis/               # Análise exploratória de dados
│   └── [seus notebooks aqui]
│
├── 05_training/               # Treinamento do modelo
│   └── treinamento.ipynb
│
└── 06_results/                # Resultados e modelos salvos
    ├── BERTimbau/
    ├── BERT multilingual/
    └── XLMRoberta/
```

---

## 🔄 Pipeline Completo

### 1️⃣ Coleta de Dados (`01_collection/`)

**Objetivo:** Coletar avaliações e comentários em português de diversas fontes.

**Notebooks disponíveis:**
- `extração_dos_dados.ipynb`: Coleta de reviews da Google Play Store usando google-play-scraper

**Funcionalidades:**
- Extração de reviews de múltiplos apps
- Coleta por nota (1-5 estrelas)
- Diferentes critérios de ordenação (MOST_RELEVANT, NEWEST)
- Exportação para CSV

**Saída:** Dataset bruto com textos (content) e notas (score)

---

### 2️⃣ Reannotação com Gemini (`02_reannotation/`)

**Objetivo:** Refinar e validar as anotações dos dados usando Gemini API.

**Notebooks disponíveis:**
- `reannotation_gemini_2.5_pro.ipynb`: Reannotação automática usando Gemini 2.5 Pro

**Funcionalidades:**
- Reannotação de avaliações com Gemini API
- Prompt detalhado para classificação 1-5 estrelas
- Modo thinking para melhor raciocínio
- Validação e tratamento de erros
- Coluna adicional: `score_reanotado_gemini`

**Saída:** Dataset com labels refinados e validados pela IA

---

### 3️⃣ Limpeza de Dados (`03_cleaning/`)

**Objetivo:** Preprocessar e limpar os dados coletados.

**Abordagens disponíveis:**

**Opção 1: Limpeza Simples (demojize)**
- Conversão de emojis para texto descritivo
- Remoção de espaços duplicados
- Normalização básica

**Opção 2: Limpeza + Filtragem (demojize + LeIA)**
- Conversão de emojis para texto descritivo
- Remoção de espaços duplicados
- **Filtragem de incoerências usando LeIA** (remove avaliações onde score e sentimento do texto são conflitantes)

**Opção 3 (Opcional): Divisão dos Dados**
- Separação em treino/validação/teste
- Pode ser feita nesta etapa ou durante o treinamento

**Scripts disponíveis:**
- `data_cleaning.ipynb`: Limpeza básica com demojize
- `data_cleaning_and_filtering_leia.ipynb`: Limpeza + filtragem de incoerências com LeIA
- `data_splitting.ipynb`: Divisão opcional dos dados

**Saída:** Dataset limpo (com ou sem filtragem de incoerências)

---

### 4️⃣ Análise Exploratória (`04_analysis/`)

**Objetivo:** Entender os dados através de estatísticas e visualizações.

**Notebooks disponíveis:**
- Pasta disponível para análises exploratórias futuras

**Análises recomendadas:**
- Distribuição de classes (sentimentos)
- Comprimento dos textos
- Palavras mais frequentes (word clouds)
- Análise de emojis
- Correlações entre features

**Saída:** Gráficos, estatísticas e insights sobre os dados

---

### 5️⃣ Treinamento (`05_training/`)

**Objetivo:** Treinar e avaliar o modelo BERTimbau.

**Notebooks disponíveis:**
- `treinamento.ipynb`: Notebook completo de treinamento do BERTimbau

**Hiperparâmetros utilizados:**
- Batch size: 8
- Learning rate: 3e-5
- Epochs: 10
- Dropout: 0.3
- Weight Decay: 0.01
- Warmup: 10% dos steps
- Scheduler: Linear com warmup

**Saída:** Modelo treinado e métricas de avaliação

---

### 6️⃣ Resultados Salvos (`06_results/`)

**Objetivo:** Armazenar modelos treinados e resultados de experimentos.

**Conteúdo:**
- `BERTimbau/`: Resultados do modelo BERTimbau
- `BERT multilingual/`: Resultados do modelo BERT multilingual
- `XLMRoberta/`: Resultados do modelo XLM-RoBERTa

**Arquivos salvos:**
- Modelos treinados (.pt, .bin)
- Métricas de avaliação
- Gráficos de treinamento
- Matrizes de confusão

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
# 1. Coletar dados
jupyter notebook 01_collection/extração_dos_dados.ipynb

# 2. Reannotar com Gemini (opcional, mas recomendado)
jupyter notebook 02_reannotation/reannotation_gemini_2.5_pro.ipynb

# 3. Limpar dados (escolha uma abordagem)
# Opção A: Limpeza simples
jupyter notebook 03_cleaning/data_cleaning.ipynb
# Opção B: Limpeza + filtragem de incoerências
jupyter notebook 03_cleaning/data_cleaning_and_filtering_leia.ipynb
# Opção C (Opcional): Dividir dados
jupyter notebook 03_cleaning/data_splitting.ipynb

# 4. Análise exploratória (opcional)
jupyter notebook 04_analysis/eda.ipynb

# 5. Treinar modelo
jupyter notebook 05_training/treinamento.ipynb
```

---

## 📊 Datasets Utilizados

### Dataset Final

- **Total de exemplos:** [número]
- **Distribuição de classes:**
  - Extremamente Negativo: [%]
  - Negativo: [%]
  - Neutro: [%]
  - Positivo: [%]
  - Extremamente Positivo: [%]

- **Divisão:**
  - Treino: 80%
  - Validação: 10%
  - Teste: 10%

### Fontes de Dados

[Liste aqui as fontes utilizadas, se públicas]

---

## 📈 Resultados do Treinamento

### Melhores Hiperparâmetros

```python
{
    "learning_rate": 3e-5,
    "batch_size": 8,
    "epochs": 10,
    "dropout": 0.3,
    "weight_decay": 0.01,
    "warmup_steps": 10%
}
```

### Métricas no Conjunto de Teste

| Métrica | Valor |
|---------|-------|
| Acurácia | [%] |
| F1-Score (macro) | [score] |
| Precisão | [%] |
| Recall | [%] |

---

## 🔧 Reprodutibilidade

### Seeds Utilizadas

Para garantir reprodutibilidade, as seguintes seeds foram fixadas:

```python
SEED = 42
random.seed(SEED)
np.random.seed(SEED)
torch.manual_seed(SEED)
torch.cuda.manual_seed_all(SEED)
```

### Ambiente

- **Python:** 3.9+
- **PyTorch:** 2.0+
- **Transformers:** 4.30+
- **CUDA:** 11.8+ (opcional, para GPU)

---

## 📝 Notas Importantes

1. **Dados Sensíveis:** Certifique-se de que nenhum dado sensível ou proprietário foi incluído nos scripts.

2. **Licenciamento:** Todos os scripts estão sob licença MIT (veja arquivo LICENSE na raiz).

3. **Citação de Datasets:** Se utilizou datasets públicos, cite-os adequadamente nos scripts.

4. **Ética:** Respeite os termos de uso das fontes de dados e robots.txt ao fazer scraping.

---

## 📚 Documentação Adicional

- **README.txt** (raiz): Instruções de uso do sistema completo
- **api/README.md**: Documentação técnica da API
- **api/TRAINING.md**: Explicação visual dos conceitos de treinamento

---

## 📧 Contato

Para dúvidas sobre os scripts e metodologia:

**Lucas Evandro Theisen**  
[seu-email@exemplo.com]

---

## 📄 Licença

Este projeto está licenciado sob:
- **Código:** MIT License
- **Trabalho Acadêmico:** Creative Commons BY 4.0

Veja o arquivo `LICENSE` na raiz do projeto para mais detalhes.

---

**Nota:** Esta documentação faz parte do TCC "Sistema de Análise de Sentimentos para Avaliações em Português Brasileiro Utilizando Deep Learning", desenvolvido na UTFPR - Campus Santa Helena.
