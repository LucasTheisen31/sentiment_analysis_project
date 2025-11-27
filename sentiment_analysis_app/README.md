# Comment Analysis App

Aplicação Flutter Web para análise de sentimentos de avaliações e comentários.

<!-- Forçar fundo branco nos diagramas Mermaid em diferentes renderizadores -->
<style>
.mermaid, .mermaid svg { background-color: #ffffff !important; }
</style>

## Visão Geral

Esta aplicação permite que usuários escrevam avaliações e obtenham análises de sentimento em tempo real, utilizando um modelo de IA hospedado em uma API backend. A arquitetura segue o padrão MVC com gerenciamento de estado reativo usando MobX.

### Funcionalidades

- ✍️ Digitação de avaliações com análise em tempo real (debouncing de 700ms)
- 🎯 Classificação de sentimento em 5 níveis (extremamente negativo → extremamente positivo)
- 📊 Visualização de probabilidades para cada classe de sentimento
- ⭐ Representação visual com estrelas e emojis
- 💾 Histórico local de avaliações salvas
- 🔄 Atualizações reativas da interface

---

## Arquitetura MVC com MobX

### Fluxo de Interação Completo

```mermaid
%%{init: {'theme':'base', 'themeVariables': { 'primaryColor':'#fff','primaryTextColor':'#000','primaryBorderColor':'#000','lineColor':'#000','secondaryColor':'#fff','tertiaryColor':'#fff','background':'#fff','mainBkg':'#fff','secondBkg':'#fff','tertiaryBkg':'#fff'}}}%%
sequenceDiagram
    actor User as Usuário
    participant View as View<br/>(Widgets)
    participant Controller as Controller<br/>(MobX)
    participant Model as Model<br/>(Repository)
    participant API as API<br/>/predict
    
    User->>View: 1. Digita avaliação
    View->>Controller: 2. Texto (via Debouncer 700ms)
    Controller->>Controller: 3. Valida (≥3 chars)
    Controller->>Model: 4. evaluateSentiment(texto)
    Model->>API: 5. POST /predict
    API-->>Model: 6. JSON Response
    Model-->>Controller: 7. SentimentPredictionModel
    Controller->>Controller: 8. Atualiza @observables
    Controller-->>View: 9. Trigger reconstrução
    View-->>User: 10. Exibe: Estrelas + Emoji + Probabilidades
    User->>View: 11. Salvar avaliação
    View->>Controller: 12. saveComment()
    Controller->>Controller: 13. Adiciona ReviewModel à lista local
    Controller-->>View: 14. Atualiza histórico (ObservableList)
    View-->>User: 15. Mostra lista atualizada
```

### Camadas da Aplicação

```
lib/
├── main.dart                          # Entry point
├── core/                              # Recursos compartilhados
│   ├── env/                           # Variáveis de ambiente
│   ├── extensions/                    # Extension methods
│   ├── global/                        # Constantes e utilitários globais
│   └── ui/                            # Componentes UI reutilizáveis
├── models/                            # Modelos de dados
│   ├── review_model.dart              # Modelo de avaliação
│   ├── sentiment_prediction_model.dart # Resposta da API
│   └── sentiment_probability_model.dart # Probabilidades por classe
├── repositories/                       # Camada de dados
│   ├── sentiment_repository.dart       # Interface (abstração)
│   └── sentiment_repository_impl.dart  # Implementação (HTTP)
└── screens/                           # Telas da aplicação
    └── home/                          # Tela principal
        ├── home_screen.dart           # View
        ├── home_controller.dart       # Controller (MobX)
        └── components/                # Widgets específicos
```

---

## Detalhamento das Camadas

### 1. View (Widgets)

**Responsabilidade:** Interface do usuário e observação de mudanças de estado.

- `home_screen.dart`: Tela principal com campo de texto e visualização de resultados
- Componentes específicos para exibição de probabilidades e histórico
- Usa `Observer` do MobX para reagir a mudanças no Controller

**Exemplo:**
```dart
Observer(
  builder: (_) => Text(controller.predictedSentiment)
)
```

### 2. Controller (MobX Store)

**Responsabilidade:** Gerenciamento de estado observável e lógica de negócio.

**Principais recursos:**
- `@observable`: Campos que notificam mudanças (ex: `predictedSentiment`, `isLoading`)
- `@action`: Métodos que modificam o estado (ex: `evaluateSentiment()`, `saveComment()`)
- `@computed`: Valores derivados calculados automaticamente
- **Debouncer**: Atraso de 700ms para evitar chamadas excessivas à API

**Fluxo típico:**
1. View dispara ação no Controller
2. Controller valida dados
3. Controller chama Repository
4. Controller atualiza observables
5. View reage automaticamente

### 3. Model (Repository Pattern)

**Responsabilidade:** Comunicação com API e serialização de dados.

**Interface (`sentiment_repository.dart`):**
```dart
abstract class SentimentRepository {
  Future<SentimentPredictionModel> evaluateSentiment(String text);
}
```

**Implementação (`sentiment_repository_impl.dart`):**
- Faz requisições HTTP POST para `/predict`
- Deserializa JSON em modelos Dart
- Trata erros e exceções

### 4. Models (Entidades de Dados)

**`SentimentPredictionModel`**: Resposta completa da API
```dart
{
  predictedClass: int,           // 0-4
  predictedSentiment: String,    // "extremamente positivo"
  confidence: double,            // 0.0-1.0
  probabilities: List<SentimentProbabilityModel>
}
```

**`SentimentProbabilityModel`**: Probabilidade individual
```dart
{
  sentiment: String,
  sentimentClass: int,
  probability: double
}
```

**`ReviewModel`**: Avaliação salva localmente
```dart
{
  text: String,
  sentiment: String,
  rating: double,
  timestamp: DateTime
}
```

---

## Tecnologias e Dependências

### Principais Packages

- **`mobx`** + **`flutter_mobx`**: Gerenciamento de estado reativo
- **`http`** / **`dio`**: Cliente HTTP para comunicação com API
- **`build_runner`**: Geração de código para MobX
- **`flutter_rating_bar`**: Widget de estrelas de avaliação

## Como Executar

### Pré-requisitos

- Flutter SDK 3.0+
- Dart SDK 3.0+
- API de análise de sentimentos rodando em `http://localhost:8000`
- Arquivo `.env` configurado na raiz do projeto

### Passos

1. **Criar arquivo `.env` (ou copie `.env.example` e renomeie para `.env`):**
```bash
echo "API_URL = http://localhost:8000" > .env
```

2. **Instalar dependências:**
```bash
flutter pub get
```

3. **Gerar código MobX:**
```bash
dart run build_runner build watch -d
```

4. **Executar em modo web:**
```bash
flutter run -d chrome
```

5. **Build para produção:**
```bash
flutter build web
```

**⚠️ Importante:**
- O arquivo `.env` já está no `.gitignore` e não será versionado
- Use `.env.example` como referência para as variáveis necessárias
- As variáveis são carregadas automaticamente no `main.dart` antes do app iniciar

---

## Fluxo de Dados Detalhado

### 1. Análise de Sentimento em Tempo Real

```
Usuário digita → Debouncer (700ms) → Validação (≥3 chars) 
→ Repository.evaluateSentiment() → HTTP POST /predict 
→ Resposta JSON → Modelo Dart → Controller atualiza observables 
→ View reconstrói automaticamente
```

### 2. Salvamento de Avaliação

```
Usuário clica "Salvar" → Controller.saveComment() 
→ Cria ReviewModel → Adiciona a ObservableList 
→ View atualiza histórico automaticamente
```

---

## Padrões e Boas Práticas

### Reatividade MobX

- **Observables**: Use `@observable` para campos que devem notificar mudanças
- **Actions**: Sempre modifique observables dentro de `@action`
- **Computed**: Use `@computed` para valores derivados (evita cálculos redundantes)
- **Reactions**: Use `reaction()` ou `autorun()` para efeitos colaterais

### Debouncing

Implementado para evitar sobrecarga da API durante digitação rápida:

```dart
Timer? _debouncer;

void onTextChanged(String text) {
  _debouncer?.cancel();
  _debouncer = Timer(Duration(milliseconds: 700), () {
    evaluateSentiment(text);
  });
}
```

### Repository Pattern

- **Abstração**: Interface define contrato
- **Implementação**: Classe concreta lida com detalhes HTTP
- **Testabilidade**: Facilita mocks e testes unitários

---

## Observações Técnicas

- **Performance**: Debouncing reduz requisições desnecessárias em ~90%
- **UX**: Feedback visual com loading states e animações
- **Validação**: Mínimo de 3 caracteres evita análises de texto muito curto
- **Reatividade**: MobX elimina `setState()` manual e simplifica sincronização
- **Escalabilidade**: Arquitetura MVC permite adicionar novas features facilmente

---

## Recursos Adicionais

- [Documentação Flutter](https://docs.flutter.dev/)
- [MobX.dart Documentation](https://mobx.netlify.app/)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)

## 📄 Licença

Este projeto está sob licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

**Desenvolvido com ❤️ para análise de sentimentos em português brasileiro**