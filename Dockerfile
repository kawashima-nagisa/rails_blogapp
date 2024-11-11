# Dockerfile
# syntax=docker/dockerfile:1
FROM ruby:3.1.2

# 必要なパッケージをインストール
# RUN apt-get update -qq && apt-get install -y \
#   postgresql-client \
#   graphviz \
#   libv8-dev \
#   imagemagick

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client graphviz imagemagick

WORKDIR /app

# GemfileとGemfile.lockをコピーしてbundle install
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# コンテナ起動時に実行されるスクリプトのパーミッションを設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# ポート設定
EXPOSE 3000

# コンテナのデフォルトのコマンドを設定
CMD ["rails", "server", "-b", "0.0.0.0"]
