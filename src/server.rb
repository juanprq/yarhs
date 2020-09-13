require 'socket'
require 'etc'

PORT = 8080
CPU_COUNT = Etc.nprocessors

request_number = 1

pipe = Ractor.new do
  loop do
    Ractor.yield(Ractor.recv, move: true)
  end
end

workers = CPU_COUNT.times.map do |actor_id|
  Ractor.new(pipe, name: "worker-#{actor_id}")  do |pipe|
    loop do
      session = pipe.take
      puts "por aqui!"

      data = session.recv(1024)
      p data
      puts "incoming request received by worker: #{name}"

      session.puts 'HTTP/1.1 200'
      session.puts 'Content-Type: text/html'
      session.puts
      session.puts "Hello world! The time is #{Time.now}, worker_id: #{name}"

      session.close
    end
  end
end

server = TCPServer.new(PORT)
puts "server listening on port: #{PORT}, cpu's: #{CPU_COUNT}"

loop do
  conn, _ = server.accept

  pipe.send(conn, move: true)
  request_number += 1
end
