

# Usa imagem base do nginx
FROM nginx:alpine

# Copia os arquivos gerados pelo Flutter Web para a pasta do Nginx
COPY ./build/web /usr/share/nginx/html

# Substitui a configuração padrão do Nginx
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf