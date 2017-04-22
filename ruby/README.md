# エコーサーバ（Ruby）の使い方

1. サーバを起動します
```
ruby echo_server.rb
```
2.  ターミナルで以下のコマンドを実行します
```
telnet localhost 3000
```
3. 'exit'を入力するとサーバとの接続が解除されます

# コーディングチェック（おまけ）

下記を実行しエラーが出た内容はある修正を行うようにする。

```bash
bundle exec rubocop
```

※ -a オプションを付けて実行すると、規約に沿っていない箇所をある程度自動で修正してくれる。

```bash
bundle exec rubocop -a
```
