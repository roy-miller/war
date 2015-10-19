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

class MockWarSocketClient
  def initialize
    TCPSocket.new('localhost', 2000)
  end
end

describe WarServer do
  it 'is not listening on default port' do
    server = WarServer.new
    begin
      client = MockWarSocketClient.new
      expect(false).to be true
    rescue => e
      puts e.message
      expect(e.message).to match(/socket/i)
    end
  end
end
