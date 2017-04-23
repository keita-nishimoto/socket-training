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

# TCPで接続を行う（シングルタスク）

1. ruby/tcp_receive_server.rb を起動させます

```bash
ruby ruby/tcp_receive_server.rb

[option]
--host: 受信に使用するホスト名またはIPアドレス
--port: 受信に使用するポート番号
```

2. クライアント(シングルタスク)を起動します

```bash
ruby ruby/tcp_single_sender.rb --host=127.0.0.1 --port=3000 --split=8 ruby/data.txt

--host: 送信先ホスト名またはIPアドレス
--port: 送信先ポート番号
--split: ファイルの分割数
ruby/data.txt: 送信するファイル名
```

# TCPで接続を行う（マルチタスク）

1. ruby/tcp_receive_server.rb を起動させます

```bash
ruby ruby/tcp_receive_server.rb

[option]
--host: 受信に使用するホスト名またはIPアドレス
--port: 受信に使用するポート番号
```

2. クライアント(マルチタスク)を起動します

```bash
ruby ruby/tcp_multi_sender.rb --host=127.0.0.1 --port=3000 --thread=8 ruby/data.txt
--host: 送信先ホスト名またはIPアドレス
--port: 送信先ポート番号
--thread: スレッド数(分割数)
ruby/data.txt: 送信するファイル名
```

# UDPで接続を行う（シングルタスク）

1. ruby/udp_receive_server.rbを起動します

```bash
ruby ruby/udp_receive_server.rb --host=0.0.0.0 --port=3000 -s
[option]
--host: 受信に使用するホスト名またはIPアドレス
--port: 受信に使用するポート番号
-s: シーケンス制御をする
```

2. クライアント(シングルタスク)を起動します

```bash
ruby ruby/udp_single_sender.rb --host=127.0.0.1 --port=3000 --split=8 ruby/data.txt
--host: 送信先ホスト名またはIPアドレス
--port: 送信先ポート番号
--split: ファイルの分割数
ruby/data.txt: 送信するファイル名
```

# UDPで接続を行う（マルチタスク）

1. ruby/udp_receive_server.rbを起動します

```bash
ruby ruby/udp_receive_server.rb --host=0.0.0.0 --port=3000 -s
[option]
--host: 受信に使用するホスト名またはIPアドレス
--port: 受信に使用するポート番号
-s: シーケンス制御をする
```

2. クライアント（マルチタスク）を起動します

```
ruby ruby/udp_multi_sender.rb --host=127.0.0.1 --port=3000 --thread=8 ruby/data.txt
--host: 送信先ホスト名またはIPアドレス
--port: 送信先ポート番号
--thread: スレッド数
ruby/data.txt: 送信するファイル名
```

# コーディングチェック（おまけ）

下記を実行しエラーが出た内容は修正を行うようにする。

```bash
bundle exec rubocop
```

※ -a オプションを付けて実行すると、規約に沿っていない箇所をある程度自動で修正してくれる。

```bash
bundle exec rubocop -a
```
