# エコーサーバ（Ruby）の使い方

1. サーバを起動します
```
ruby ruby/echo_server.rb
```
2.  ターミナルで以下のコマンドを実行します
```
telnet localhost 3000
```
3. 'exit'を入力するとサーバとの接続が解除されます

# UDPで送信を行う

関連するファイルは以下の2つです。

- ruby/udp_receiver.rb
- ruby/udp_sender.rb

1. udp_receiverを実行します

```bash
ruby ruby/udp_receiver.rb
```

2. 別のターミナルを開きudp_sender.rbを実行します

```bash
ruby ruby/udp_sender.rb
```

udp_receiver.rb を起動させているターミナルに以下のように表示されます。

```text
ReceiverStart:127.0.0.1:3000
"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
```

# コーディングチェック（おまけ）

下記を実行しエラーが出た内容はある修正を行うようにする。

```bash
bundle exec rubocop
```

※ -a オプションを付けて実行すると、規約に沿っていない箇所をある程度自動で修正してくれる。

```bash
bundle exec rubocop -a
```
