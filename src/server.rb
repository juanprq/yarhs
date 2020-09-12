require 'socket'

port = 8080
server = TCPServer.new(port)

puts "server listening on port: #{port}"
while session = server.accept
  request = session.gets
  puts request

  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: text/html\r\n"
  session.print "\r\n"
  session.print "Hello world! The time is #{Time.now}"

  session.close
end
