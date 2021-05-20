# メモアプリ
ブラウザで起動するメモアプリです。

## 機能
新規メモの作成、閲覧、削除、更新ができます。

## 環境
- Ruby 3.0.0
- Bundler 2.2.13
- psql (PostgreSQL) 13.3

## 使い方の手順
1.  自身のpcへクローンしてください。
2.  `$ createdb memo_app` で memo_appのデータベースを作成します。
4.  `$ psql memo_app` でmemo_appのデータベースへ接続してください。
6.  `memo_app=# CREATE TABLE memos (id VARCHAR, title VARCHAR, content VARCHAR);` でmemosのテーブルを作成してください。
7.  `memo_app=# \q` でデータベース接続を終えてください。
8.  クローンしたディレクトリ内で`$ bundle install`
9.  `$ bundle exec ruby app.rb` で起動します。
10.  http://localhost:4567/memos がトップ画面です。新規作成でメモを書きます！
11.  メモのタイトルをクリックすると、メモの中身を閲覧できます。編集、削除についてはこのページから行ってください。

