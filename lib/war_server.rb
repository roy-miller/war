require 'socket'

class WarServer
  attr_accessor :port, :socket, :pending_clients, :clients

  def initialize(port: 2000)
    @port = port
    @socket = TCPServer.open('localhost', port)
    @pending_clients = []
    @clients = []
  end

  def start
    loop do
      Thread.start(@socket.accept) do |client|
        pair_players(client)
      end
    end
  end

  def pair_players(client)
    client.puts 'Welcome to war! Connecting you with a partner ...'
    @pending_clients << client
    if @pending_clients.count == 2
      @clients << @pending_clients.shift
      @clients << @pending_clients.shift
      # play_game
    end

    # begin
    #   while input = client.read_nonblock(1000)
    #     ask_for_name(client: client)
    #     get_name(client: client)
    #     save the name and socket together somehow
    #     if there aren't two, tell him to wait (how does this work with threads?)
    #     if there are two, start game and tell him who he's playing
    #     if @pending_clients.length > 1
    #       @clients << @pending_clients.shift
    #       @clients << client
    #       play_game(@clients.first, @clients.last)
    #     else
    #       @pending_clients << client
    #     end
    #   end
    # rescue IO::WaitReadable
    #   retry
    # end
  end

  def stop
    @pending_clients.each { |client| stop_connection(client: client) }
    @clients.each { |client| stop_connection(client: client) }
    # connections = []
    # @pending_clients.each { |client| connections << client }
    # @clients.each { |client| connections << client }
    # connections.each { |client| stop_connection(client: client) }
    @socket.close unless @socket.closed?
  end

  def stop_connection(client:)
    @pending_clients.delete(client)
    @clients.delete(client)
    client.close unless client.closed?
  end

  def ask_for_name(client:)
    client.puts("Enter your name:")
  end

  def get_name(client:)
    begin
      client.read_nonblock(1000)
    rescue IO::WaitReadable
      IO.select([client])
      retry
    end
  end

  def play_game
    # game = Game.new
    # game.add_player(Player.new(player1_name))
    # game.add_player(Player.new(player2_name))
    # game.play -> play_round until 1 player runs out of cards
  end
end
