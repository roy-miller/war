require 'socket'
require 'json'

class WarClient
  attr_accessor :unique_id, :socket, :server_address, :port

  def initialize(server_address: 'localhost', port: 2000)
    @server_address = server_address
    @port = port
  end

  def connect
    @socket = TCPSocket.open(@server_address, @port)
  end

  def ask_to_play(output=$stdout)
    response = receive
    @unique_id = response[:unique_id]
    output.puts response[:message]
  end

  def play_game(output=$stdout)
    #while (response = receive)
    #response = receive

  end

  def receive
    response_json_string = nil
    begin
      response_json_string = @socket.read_nonblock(1000).chomp
    rescue IO::WaitReadable
      IO.select([@socket])
      retry
    end
    response_hash = JSON.parse(response_json_string, :symbolize_names => true)
    response_hash
  end

end
