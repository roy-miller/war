require 'socket'

class WarServer
  attr_accessor :port, :socket

  def initialize(port = 2000)
    @port = port
    @socket = TCPServer.open(port)
    @pending_clients = []
    @clients = []
  end

  def start
    Thread.new {
      loop do
        Thread.start(@socket.accept) do |client|
          client.puts 'Welcome to war!'
          #@pending_clients << client
          begin
            while input = client.gets
              puts "server received: #{input}"

              ask_for_name(client: client)
              client.puts "Welcome, #{player_name}"
              #client.close
            end
          rescue IO::WaitReadable
            retry
          end
          #if @pending_clients.length == 2

            #puts("Welcome, #{player_name}")
          #end
        end
      end
    }
  end

  def ask_for_name(client: $stdout)
    client.puts("Enter your name:")
  end
end

#WarServer.new(2000).start
