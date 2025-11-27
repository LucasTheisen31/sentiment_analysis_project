#!/bin/bash

# Verifica se o arquivo 'best_model_state.bin' existe no diretório 'assets'
if [ ! -f ./assets/best_model_state.bin ]; then
    echo "Arquivo do modelo não encontrado, iniciando download..."
    
    # Verifica se o ID do modelo foi fornecido
    if [ -z "$MODEL_ID" ]; then
        echo "Erro: $MODEL_ID não foi definido. Defina o ID do modelo e tente novamente."
        exit 1
    fi

    # Faz o download do arquivo do modelo usando o ID especificado em $MODEL_ID
    gdown --id "$MODEL_ID" -O ./assets/best_model_state.bin
else
    echo "Arquivo do modelo encontrado em './assets/best_model_state.bin'."
fi

uvicorn sentiment_analyzer.api:app --host 0.0.0.0
# Inicia o servidor Uvicorn com a aplicação FastAPI.
# `sentiment_analyzer.api:app` aponta para o módulo `sentiment_analyzer.api` e a instância `app` da aplicação FastAPI.
# `--host 0.0.0.0` faz com que o servidor seja acessível externamente, ou seja, ele escuta em todas as interfaces de rede.