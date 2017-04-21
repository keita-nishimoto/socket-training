/**
 * TCPのエコーサーバ
 */
const net = require('net');

// TCPサーバの作成
const server = net.createServer();

// 最大接続数を設定
server.maxConnections = 10;

// 接続イベントの定義
server.on('connection', (socket) => {
  let data = '';
  const newline = /\r\n|\n/;

  // データ受信イベントの定義
  socket.on('data', (chunk) => {
    const chunkString = chunk.toString();
    if (chunkString === 'exit' + "\r\n" || chunkString === 'exit' + "\n") {
      // chunkの中身がexitの場合は接続終了と見なす
      socket.end();
    }
    data += chunkString;
    const client = socket.remoteAddress + ':' + socket.remotePort;

    // 改行コードが含まれているか？
    if (newline.test(data)) {
      console.log(client + " >> " + data);
      // 受け取ったデータを返送する
      if (socket.writable) {
        socket.write("RET: " + data);
      }
      data = '';
    }
  });
});

// 接続断イベントを定義する
server.on('close', () => {
  console.log('Server Closed');
});

// 待受アドレスとポートを指定し、接続待ちをおこなう
server.listen(3000, '127.0.0.1', () => {
  const addr = server.address();
  console.log('Start Server - ' + addr.address + ':' + addr.port);
});
