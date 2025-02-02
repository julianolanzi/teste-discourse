# Usa uma imagem mínima do Ubuntu
FROM ubuntu:22.04

# Define o diretório de trabalho
WORKDIR /app

# Atualiza e instala dependências do sistema
RUN apt-get update && apt-get install -y \
    curl wget git sudo build-essential \
    libpq-dev libxml2-dev libxslt-dev imagemagick \
    libcurl4-openssl-dev libssl-dev \
    redis-server postgresql-client \
    ruby-full zlib1g-dev && \
    apt-get clean

# Adiciona um usuário para rodar o Discourse
RUN useradd -m discourse && \
    mkdir -p /home/discourse && \
    chown -R discourse:discourse /home/discourse

# Define o usuário para evitar problemas de permissão
USER discourse

# Instala o Bundler e verifica a versão correta
RUN gem install bundler -v 2.4.22

# Copia os arquivos do projeto para o container
COPY --chown=discourse:discourse . .

# Instala as gems do Discourse
RUN bundle install --jobs 4 --retry 3 --without test development

# Expõe a porta usada pelo Discourse
EXPOSE 3000

# Comando para iniciar o Discourse
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p 3000"]
