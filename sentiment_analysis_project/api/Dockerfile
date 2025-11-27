# Usa a imagem base do Python 3.11 com uma versão leve do Debian
FROM python:3.11-slim

# Define o diretório de trabalho dentro do container como /api
WORKDIR /api

# Define o fuso horário para São Paulo
ENV TZ=America/sao_paulo

# Define o ID do modelo como variável de ambiente
ENV MODEL_ID=seu_id_aqui

# Copia o arquivo de dependências "requirements.txt" para o container
COPY requirements.txt requirements.txt

# Instala as dependências do projeto usando o pip
RUN pip3 install -r requirements.txt

# Copia todos os arquivos e pastas do projeto local para dentro do container
COPY . .
RUN ls -l /api/assets

# Expõe a porta 8000 do container
EXPOSE 8000

# Cria a pasta ./assets dentro do diretório de trabalho, caso não exista
RUN mkdir -p ./assets

# Garante que o script tenha permissão de execução
RUN chmod +x bin/start_server.sh

# Define o comando que será executado ao iniciar o container
CMD ["bin/start_server.sh"]
