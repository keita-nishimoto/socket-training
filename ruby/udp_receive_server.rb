require 'socket'
require 'optparse'
require 'digest/sha1'

# デフォルトホストアドレス
host = '127.0.0.1'
# デフォルトポート番号
ports = [*3000..3016]
# 受信バッファサイズ(512M)
maxlen = 1024 * 1024 * 512

# シーケンス制御時用データ保存ワークデータ
seq_data = {}

# 引数チェック
begin
  params = ARGV.getopts('sd', 'host:', 'port:', 'len:')
rescue OptionParser::ParseError => e
  puts e.message
  exit(-1)
end

# ホスト名（IPアドレス）が指定されたか
host = params['host'] unless params['host'].nil?

# ポート番号が指定されたか
unless params['port'].nil?
  ports = []
  params['port'].split(',').each do |port|
    ports.push(port.to_i)
  end
end

# バッファ受信サイズが指定されたか
maxlen = params['len'].to_i unless params['len'].nil?

# シーケンスモード
seq_cntl = params['s']

# デバッグモード
dump = params['d']

puts 'SequenceMode' if seq_cntl

puts "Server Start - MaxDataReceiveSize: #{maxlen}"

begin
  ports.each do |port|
    # ソケット（UDP）をオープンする
    _socket = UDPSocket.open
    # 待受アドレスとポートを指定する
    _socket.bind(host, port)
    puts "bind - #{host}:#{port}"

    # スレッドを起動する
    Thread.start(_socket) do |socket|
      loop do
        # ソケットの読み取りが可能になるまで待つ
        IO.select([socket])
        # 処理開始時刻取得
        start_time = Time.now.instance_eval { to_i * 1000 + (usec / 1000) }
        # データを受信する
        buffer, addr = socket.recvfrom_nonblock(maxlen)
        if seq_cntl
          # シーケンス制御あり
          seq, digest, data = buffer.split(':', 3)
          puts "#{addr[2]}:#{addr[1]} >> seq: #{seq} length: #{buffer.length}"
          if seq_data[digest].nil?
            seq_data[digest] = Array.new(data.to_i)
            puts "last sequence no: #{data}"
          else
            seq_data[digest][seq.to_i - 1] = data
            if seq_data[digest].all?
              puts "all received - #{addr[2]}:#{addr[1]}"
              seq_data.delete(digest)
            end
          end
        else
          # シーケンス制御なし
          puts "#{addr[2]}:#{addr[1]} >> length: #{buffer.length}"
        end
        # 処理終了時刻取得
        end_time = Time.now.instance_eval { to_i * 1000 + (usec / 1000) }
        # 処理時間算出(ミリ秒)
        interval = end_time - start_time
        puts "processing #{interval} msec"
      end
    end
  end
  # メインスレッドが処理終了しないよう無限ループに
  loop do
    sleep(1000)
  end
rescue Interrupt
  # Ctrl-C で終了する
rescue => e
  p e
end

puts 'Server closed'
