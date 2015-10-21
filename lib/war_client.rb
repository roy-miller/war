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
    #ask_to_play
  end

  def ask_to_play(output=$stdout)
    response = get_server_output
    puts "got this back: #{response}"
    @unique_id = response[:unique_id]
    output.puts response[:message]
  end

  def provide_name(name)
    payload = { input: name }
    @socket.puts JSON.dump(payload)
  end

  def play_next_round
    payload = { input: "\n" }
    @socket.puts JSON.dump(payload)
  end

  def play_game(output=$stdout)
    while response = get_server_output
      puts "got some server output"
      output.puts response
      puts "waiting for user input"
      while input = get_user_input
        puts "got user input: #{input}"
        @socket.puts input
      end
    end
  end

  def get_user_input
    gets.chomp
  end

  def get_server_output
    response_json_string = nil
    begin
      response_json_string = @socket.read_nonblock(1000).chomp
    rescue IO::WaitReadable
      IO.select([@socket])
      retry
    end
    response_hash = JSON.parse(response_json_string, :symbolize_names => true)
    response_hash
    #response_json_string
  end

end
