require 'socket'
require_relative './player.rb'
require_relative './game.rb'

class WarServer
  attr_accessor :port, :socket, :pending_clients, :clients, :game

  def initialize(port: 2000)
    @port = port
    @socket = TCPServer.open('localhost', port)
    @pending_clients = []
    @clients = {}
  end

  def games
    @games ||= []
  end

  def start
    loop do
      Thread.start(accept) do |client|
        run
      end
    end
  end

  def accept
    client = @socket.accept
    @pending_clients << client
    client.puts 'Welcome to war! Connecting you with a partner'
  end

  def run(client)
    new_game = make_game
    if new_game
      pair_clients_and_players
      play_game(new_game)
      stop_connection(client: @clients[new_game.players.first])
      stop_connection(client: @clients[new_game.players.last])
    end
  end

  def pair_clients_and_players
    @pending_clients.each_with_index do |client, index|
      clients[game.players[index]] = client
    end
  end

  def make_game
    if @pending_clients.count == 2
      ask_for_name(client: @pending_clients[0])
      player1_name = get_name(client: @pending_clients[0])
      player1 = Player.new(player1_name)

      ask_for_name(client: @pending_clients[1])
      player2_name = get_name(client: @pending_clients[1])
      player2 = Player.new(player2_name)

      game = Game.new
      game.add_player(player1)
      game.add_player(player2)
      games << game
      game
    end
  end

  def ask_for_name(client:)
    client.puts("Enter your name:")
  end

  def get_name(client:)
    begin
      text = client.read_nonblock(1000).chomp
      text
    rescue IO::WaitReadable
      IO.select([client])
      retry
    end
  end

  def play_game(new_game)
    new_game.deal
    while !new_game.over?
      winner = new_game.play_round
      congratulate_round_winner(new_game, winner)
    end
    congratulate_game_winner(new_game)
  end

  def congratulate_round_winner(a_game, winner)
    if a_game.player1 == winner
      @clients[a_game.player1].puts "You won the round!"
      @clients[a_game.player2].puts "You lost the round"
    elsif a_game.player2 == winner
      @clients[a_game.player2].puts "You won the round!"
      @clients[a_game.player1].puts "You lost the round"
    end
  end

  def congratulate_game_winner(a_game)
    if a_game.player1 == a_game.winner
      @clients[a_game.player1].puts "You won the game!"
      @clients[a_game.player2].puts "You lost the game"
    elsif a_game.player2 == a_game.winner
      @clients[a_game.player2].puts "You won the game!"
      @clients[a_game.player1].puts "You lost the game"
    end
  end

  def stop
    @pending_clients.each { |client| stop_connection(client: client) }
    @socket.close unless @socket.closed?
  end

  def stop_connection(client:)
    @pending_clients.delete(client)
    client.close unless client.closed?
  end

  # def stop_game
  #   stop_connection(@clients.first)
  #   stop_connection(@clients.last)
  # end
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
