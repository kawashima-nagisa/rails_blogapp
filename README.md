# MyBlog

## 概要
MyBlogは、Ruby on Rails7を使用して作成したブログアプリケーションです。

## 機能
- 新規登録やログイン、パスワードリセット機能, アカウント削除機能
- お問い合わせ機能
- コメント機能(テキスト、画像)
- 投稿機能(テキスト)
- 通知機能
- 検索機能(投稿日時、投稿のタイトル、カテゴリー)
- 投稿頻度確認機能
- アプリ作成者のqiita記事閲覧機能

## Rubyバージョン
- rails 7.1.3
- ruby 3.1.2

`.ruby-version`ファイルを参照してください。

## 依存関係について
- PostgreSQL
- Active Storage（image_processingおよびmini_magick Gem）
- Devise
- reCAPTCHA フォーム送信の認証
- Noticed
- Bootstrap 5
- Stimulus
- Importmap
- Ransack
- Kaminari
- Gretel
- Rails i18n
- Faker:
- Brakeman
- Letter Opener Web

## 使用したツール
- Brevo
- Mailtrap
- devcontainer


## 開発環境構築手順
1. リポジトリをクローンします
2. Dockerコンテナのビルドをします
```sh
docker-compose build
```
3. データベースの作成とmigrationをしてください

```sh
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```


4. VS CodeのDevContainerでコンテナに入る

 "コンテナで再度開く"を押します

⚠️ vscodeで拡張機能でdevcontainerを入れていることが前提です。

5. devコンテナに入ったら以下のコマンドを打ってwebサーバーを立ち上げる

```sh
bin/dev

```
6. seedデータの挿入 ダミーデータの挿入を行ってください

```sh
rails db:seed
```

## 開発作業中断時

"リモート接続を終了する"を押します

## 再度ビルドする時
"コンテナーのリビルド"を押します


