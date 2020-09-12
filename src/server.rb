require 'socket'

port = 8080
server = TCPServer.new(port)

request_number = 1

puts "server listening on port: #{port}"
while session = server.accept
  request = session.gets

  puts "incoming request: #{request_number}"
  puts request

  session.puts 'HTTP/1.1 200'
  session.puts 'Content-Type: text/html'
  session.puts
  session.print "Hello world! The time is #{Time.now}, request number: #{request_number}"

  session.close

  sleep(1)

  request_number += 1
end
