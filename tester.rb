require 'socket'

s = TCPSocket.open('localhost', 2000)
puts "got this from server: #{s.gets}"
while input = gets
  puts "user typed: #{input}"
  s.puts input
  response = s.gets
  puts "server responded -> #{response}"
end

# while line = s.gets
#  puts line.chop
# end
# begin
#   #response = s.read_nonblock(1000)
#   #puts "got this: #{response}"
#   while line = s.gets
#     puts line.chop
#   end
# rescue IO::WaitReadable
#   puts "something went wrong"
# end
# #s.close
