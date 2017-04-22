require 'socket'

# ホスト名
host = '127.0.0.1'

# ポート番号
port = 3000

# ソケットを開き、待受アドレスとポートを指定する
# この中では、socket/bindが同時に実行されている
server = TCPServer.open(host, port)

puts "ServerStart:#{host}:#{port}"

loop do
  # スレッドを作成し、ソケットへの接続を待つ(関数内部でlisten/acceptを連続して実行している)
  Thread.start(server.accept) do |socket|
    puts 'Connection Start'

    # ソケットからデータを受信する
    while (buffer = socket.gets)

      # データが"exit"なら終了と見なす
      break if buffer.strip == 'exit'

      puts "#{socket.peeraddr[2]}:#{socket.peeraddr[1]}>#{buffer.strip}"

      # 受信したデータを表示させる
      socket.puts "RET:#{buffer}"
    end

    puts 'Connection Closed'
    # ソケットをクローズする
    socket.close
  end
end

# メインソケットをクローズする
server.close
