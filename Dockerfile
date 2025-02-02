# Usa uma imagem Linux mínima como base
FROM ubuntu:22.04

# Define o diretório de trabalho
WORKDIR /app

# Instala dependências do Discourse
RUN apt-get update && apt-get install -y \
    curl wget git sudo build-essential \
    libpq-dev libxml2-dev libxslt-dev imagemagick \
    libcurl4-openssl-dev libssl-dev \
    redis-server postgresql-client \
    ruby-full && \
    gem install bundler

# Instala Node.js e Yarn (necessários para o frontend do Discourse)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Copia os arquivos do repositório para o container
COPY . .

# Instala dependências do Discourse
RUN bundle install --without test development

# Expõe a porta usada pelo Discourse
EXPOSE 3000

# Comando para iniciar o Discourse
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p 3000"]
