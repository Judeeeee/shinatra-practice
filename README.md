# Shinatraメモアプリについて
## 概要
これは、FjordBootCampの課題(提出物)です。
shinatraを用いてDBを使用しないメモアプリを作成しました。(作成メモはjsonファイルに記述される)

### セットアップ
1. `git clone`を用いてファイルをダウンロードし、ローカル環境で使用できるようにします。
` git clone https://github.com/Judeeeee/shinatra-practice`

2. Bundlerを使って必要なGemをインストールする
`gem install bundler` でbundlerが使える状態にします。
 `bundle install`で必要なgemが一斉にinstallされます。

3. ローカルサーバーの立ち上げ
コマンド`ruby myapp.rb`を入力し、`http://localhost:4567/memos/ `をブラウザのURL欄に入力します。
