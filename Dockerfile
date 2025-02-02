FROM discourse/base:2.0.20240118

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos do repositório para o container
COPY . .

# Instala dependências do Discourse
RUN apt-get update && \
    apt-get install -y libpq-dev && \
    bundle install --without test development

# Expõe a porta usada pelo Discourse
EXPOSE 80

# Comando para iniciar o Discourse
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p 80"]
