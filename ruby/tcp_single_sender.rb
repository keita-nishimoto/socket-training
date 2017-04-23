require 'socket'
require 'optparse'

# ホストアドレス
host = '127.0.0.1'
# ポート番号
port = 3000
# 分割数
divide = 1

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
divide = params['split'].to_i unless params['split'].nil?

# ファイルの読み込み & ファイル分割
puts 'reading file... ' + filename
messages = []
begin
  data = IO.binread(filename)
  len = (data.length / divide).ceil
  divide.times do |i|
    messages << data[i * len, len]
  end
rescue => e
  puts e.message
  exit(-3)
end

puts 'Connect... ' + host + ':' + port.to_s
begin
  # TCPソケットをオープンしアドレスとポートを指定する
  socket = TCPSocket.open(host, port)
rescue SocketError => e
  puts e.message
  exit(-4)
end

begin
  n = 1
  m = messages.length
  # 分割数分繰り返す
  messages.each do |message|
    puts "sending... #{n}/#{m} : #{message.length}byte"
    # データを送信
    socket.write(message)
    n += 1
  end
rescue => e
  puts e.message
end

# ソケットをクローズする
socket.close
puts 'Connection closed'

exit(0)
