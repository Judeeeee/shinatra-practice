# Shinatraメモアプリについて
## 概要
これは、FjordBootCampの課題(提出物)です。
該当プラクティスは[こちら](https://bootcamp.fjord.jp/practices/179)
DBとしてPostgreSQLを利用したメモアプリを作成しました。

### セットアップ
#### DBの設定
メモ情報を保存するために、事前にDBを設定する必要があります。

1. postgreSQLのインストール
以下のサイトを参考にPostgreSQLをインストールしてください。
- https://github.com/postgres/postgres
- https://www.postgresql.org/download/

2. DBの作成
以下のコマンドを実行して、DBを作成してください。
```
$ create database shinatra_memoapp;
```

3. テーブルの作成
2.で作成したDBへ接続して、テーブルを作成します。以下のコマンドを実行してください。

データベースへの接続
```
$ psql -d shinatra_memoapp
```
テーブルの作成
```
$ create table memodata(id text, title text, sentence text);
```

#### アプリの使用方法
1. `git clone`を用いてファイルをダウンロードし、ローカル環境で使用できるようにします。
` git clone https://github.com/Judeeeee/shinatra-practice`

2. Bundlerを使って必要なGemをインストールします。
`gem install bundler` でbundlerが使える状態にします。
 `bundle install`で必要なgemが一斉にinstallされます。

3. ローカルサーバーの立ち上げ
コマンド`ruby myapp.rb`を入力し、`http://localhost:4567/memos/ `をブラウザのURL欄に入力します。
