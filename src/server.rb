require 'socket'
require 'etc'

PORT = 8080
CPU_COUNT = Etc.nprocessors

server = TCPServer.new(PORT)

request_number = 1

puts "server listening on port: #{PORT}, cpu's: #{CPU_COUNT}"

workers = CPU_COUNT.times.map do |actor_id|
  Ractor.new name: "worker-#{actor_id}" do
    loop do
      session = Ractor.recv

      request = session.gets
      puts "incoming request received by worker: #{name}"

      session.puts 'HTTP/1.1 200'
      session.puts 'Content-Type: text/html'
      session.puts
      session.print "Hello world! The time is #{Time.now}, worker_id: #{name}"

      session.close
    end
  end
end

loop do
  conn, _ = server.accept
  worker = workers.sample

  worker.send(conn, move: true)
  request_number += 1
end
