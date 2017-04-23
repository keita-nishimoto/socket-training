require 'socket'

host = '127.0.0.1'
port = 3000

# ファイルの読み込み（5文字づつ分割）
text_data = File.read('ruby/data.txt', encoding: Encoding::UTF_8).scan(/.{1,5}/)

# 送信用ソケットアドレスを設定
sockaddr = Socket.pack_sockaddr_in(port, host)
sender = UDPSocket.open
puts "SenderStart:#{host}:#{port}"

# ファイル転送（シーケンス番号を使った独自プロトコル）
# 送信個数を送る(シーケンス番号は0番)
n = 0

sender.send("#{n}:#{text_data.count}", 0, sockaddr)

# 分割メッセージを送る(シーケンス番号は1番から)
text_data.each do |text|
  n += 1
  sender.send("#{n}:#{text}", 0, sockaddr)
end

# 送信完了
sender.close
