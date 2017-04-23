require 'socket'

host = '127.0.0.1'
port = 3000

receiver = UDPSocket.open

receiver.bind(host, port)

puts "ReceiverStart:#{host}:#{port}"

# データ宣言兼初期化
n = 0
m = 0
data_list = []

loop do
  seq, data = receiver.recv(65_535).split(':')
  if seq.to_i == 0
    # データ個数取得
    m = data.to_i
  else
    # データ取得
    # (受信データの順番が入れ替わる可能性があるのでその対応)
    data_list[seq.to_i] = data
  end
  break if m == n
  n += 1
end

p data_list.join('')

receiver.close
