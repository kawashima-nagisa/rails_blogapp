# MyBlog
https://rails-blogapp.onrender.com/
## 概要
MyBlogは、Ruby on Rails7を使用して作成したブログアプリケーションです。

## 機能
- 新規登録やログイン、パスワードリセット機能, アカウント削除機能
- お問い合わせ機能
- コメント機能(テキスト、画像)
- 投稿機能(テキスト)
- 通知機能
- 検索機能(投稿日時、投稿のタイトル、カテゴリー)
- 検索suggest機能
- 投稿頻度確認機能
- アプリ作成者のqiita記事閲覧機能
- 画像ドロップ機能

## Rubyバージョン
- rails 7.1.3
- ruby 3.1.2

`.ruby-version`ファイルを参照してください。

## 依存関係

このプロジェクトは、以下のGemやサービスに依存しています。

- **Docker環境**：開発環境のコンテナ化
- **PostgreSQL**：データベース（デフォルト設定）
- **Active Storage**：画像やファイルの保存（image_processing、mini_magick使用）
- **Devise**：認証機能
- **reCAPTCHA**：フォーム認証用API
- **Noticed**：通知機能
- **Bootstrap 5**：スタイルフレームワーク
- **Stimulus**：JavaScriptコントローラーの管理
- **Importmap**：ESMモジュールの管理
- **Ransack**：検索機能
- **Kaminari**：ページネーション
- **Gretel**：パンくずリスト
- **Rails i18n**：国際化
- **Faker**：ダミーデータ生成（開発/テスト用）
- **Brakeman**：セキュリティ分析ツール
- **Letter Opener Web**：開発環境でのメール確認
- **redcarpet**：マークダウン形式のテキストをHTMLに変換する

## テスト関連依存関係

- **RSpec Rails**：Railsテストフレームワーク
- **FactoryBot Rails**：テストデータの生成
<!-- - **Shoulda Matchers**：簡易的なバリデーションおよび関連付けのテスト -->


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


