require 'socket'
require 'optparse'
require 'digest/sha1'

# ホストアドレス
host = '127.0.0.1'
# ポート番号
port = 3000
# 分割数
divide = 1

# UDPシーケンス制御用に追加するサイズ
SOCKET_MANAGE_SIZE = 80

# 引数チェック
begin
  params = ARGV.getopts('', 'host:', 'port:', 'split:')
rescue OptionParser::ParseError => e
  puts e.message
  exit(-1)
end

if ARGV.empty?
  puts 'ファイルを指定してください'
  exit(-2)
end

filename = ARGV[0]

# ホスト名（IPアドレス）が指定されたか
host = params['host'] unless params['host'].nil?

# ポート番号が指定されたか
port = params['port'].to_i unless params['port'].nil?

# 分割数を指定されたか
unless params['split'].nil?
  divide = params['split'].to_i
  divide = 16 if divide > 16
end

# UDPソケットを開く
begin
  socket = UDPSocket.open
  # ソケットの送信バッファサイズを取得する
  bsize = socket.getsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF).int
  # UDPパケット最大サイズを超えてないか確認する
  bsize = 65_535 if bsize > 65_535
  if bsize < 65_535
    socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, 65_535)
  end
  packet_size = bsize - SOCKET_MANAGE_SIZE
  puts "packet send buffer size: #{packet_size}byte"
rescue SocketError => e
  puts e.message
  exit(-4)
end

# ファイルの読み込み & ファイル分割
puts 'reading file... ' + filename
messages = []
begin
  data = File.read(filename)
  len = (data.length / divide.to_f).ceil
  if len > packet_size
    len = packet_size
    divide = (data.length / len.to_f).ceil
  end
  divide.times do |i|
    messages << data[i * len, len]
  end
  puts "#{messages.length} #{divide}"
rescue => e
  puts e.message
  exit(-3)
end

# シーケンス制御用ダイジェスト
digest = Digest::SHA1.hexdigest(Time.now.to_s)

begin
  n = 0
  # 接続先アドレスとポートを指定しデータ送信する(シーケンス制御用ヘッダー情報)
  socket.send(n.to_s + ':' + digest + ':' + messages.length.to_s, 0, host, port)
  puts "sending... host:#{host} port:#{port}"

  n = 1
  m = messages.length
  # 分割数分繰り返す
  messages.each do |message|
    # 接続先アドレスとポートを指定しデータ送信する
    puts "sending... #{n}/#{m} : #{message.length}byte port:#{port}"
    socket.send(n.to_s + ':' + digest + ':' + message, 0, host, port)
    n += 1
  end
rescue => e
  puts e.message
end

# ソケットをクローズする
puts 'Connection closed'
socket.close

exit(0)
