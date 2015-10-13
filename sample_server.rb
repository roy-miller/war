require 'socket'

myserver = TCPServer.new('localhost', 2000)
sockaddr = myserver.addr
puts "Echo server running on #{sockaddr.join(':')}"
while true
  Thread.start(myserver.accept) do |sock|
    puts("#{sock} connected at #{Time.now}")
    while input = sock.gets
      sock.write(input)
      puts "User entered: #{input}"
    end
    puts("#{sock} disconnected at #{Time.now}")
    s.close
  end
end
