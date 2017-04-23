require 'socket'
require 'optparse'

# デフォルトのホストアドレス
host = '127.0.0.1'

# デフォルトポート番号
port = 3000

# 受信バッファサイズ(512M)
maxlen = 1024 * 1024 * 512

# 引数チェック
begin
  params = ARGV.getopts('d', 'host:', 'port:', 'len:')
rescue OptionParser::ParseError => e
  puts e.message
  exit(-1)
end

# ホスト名（IPアドレス）が指定されたか
host = params['host'] unless params['host'].nil?

# ポート番号が指定されたか
port = params['port'].to_i unless params['port'].nil?

# バッファ受信サイズが指定されたか
maxlen = params['len'].to_i unless params['len'].nil?

# デバッグモード
dump = params['d']

# TCPソケットを開きアドレスとポートを指定する
socket = TCPServer.open(host, port)

# listenでbacklogの値を設定する
socket.listen(16)

puts "Server Start - #{host}:#{port}"

begin
  loop do
    Thread.start(socket.accept) do |connection|
      puts "Connection Start - #{connection.peeraddr[2]}:#{connection.peeraddr[1]}"
      start_time = Time.now.instance_eval { to_i * 1000 + (usec / 1000) }
      # コネクションからデータをブロックモードで受信する ソケットが切断されるまで受信を続ける
      while (buffer = connection.read(maxlen))
        puts "#{connection.peeraddr[2]}:#{connection.peeraddr[1]} >> length: #{buffer.length}"
        puts "data: #{buffer}" if dump
      end
      puts "Connection Close - #{connection.peeraddr[2]}:#{connection.peeraddr[1]}"
      # コネクションをクローズする
      connection.close
      end_time = Time.now.instance_eval { to_i * 1000 + (usec / 1000) }
      interval = end_time - start_time
      puts "processing #{interval} msec"
    end
  end
rescue Interrupt
rescue => e
  p e
end

# ソケットをクローズする
socket.close
puts "Server closed - #{host}:#{port}"
