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
    until @socket.closed? do
      Thread.start(accept) do |client|
        run(client)
      end
    end
  end

  def accept
    client = @socket.accept
    @pending_clients << client
    client.puts 'Welcome to war! Connecting you with a partner'
  end

  def run(client)
    game = make_game
    if game
      pair_clients_and_players(game)
      play_game(game)
      stop_connection(client: @clients[new_game.players.first])
      stop_connection(client: @clients[new_game.players.last])
    end
  end

  def pair_clients_and_players(game)
    @pending_clients.each_with_index do |client, index|
      @clients[game.players[index]] = client
    end
  end

  def make_game
    if @pending_clients.count == 2
      player1 = get_player_for_game
      player2 = get_player_for_game

      game = Game.new
      game.add_player(player1)
      game.add_player(player2)
      games << game
      game
    end
  end

  def get_player_for_game
    client = @pending_clients.shift
    ask_for_name(client: client)
    player_name = get_name(client: client)
    Player.new(player_name)
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

  def play_game(game)
    game.deal
    while !game.over?
      winner = game.play_round
      congratulate_round_winner(game, winner)
    end
    congratulate_game_winner(game)
  end

  def congratulate_round_winner(game, winner)
    if game.player1 == winner
      @clients[game.player1].puts "You won the round!"
      @clients[game.player2].puts "You lost the round"
    elsif game.player2 == winner
      @clients[game.player2].puts "You won the round!"
      @clients[game.player1].puts "You lost the round"
    end
  end

  def congratulate_game_winner(game)
    if game.player1 == game.winner
      @clients[game.player1].puts "You won the game!"
      @clients[game.player2].puts "You lost the game"
    elsif game.player2 == game.winner
      @clients[game.player2].puts "You won the game!"
      @clients[game.player1].puts "You lost the game"
    end
  end

  def stop
    @clients.each { |key,value| stop_connection(client: value) }
    @socket.close unless @socket.closed?
  end

  def stop_connection(client:)
    @pending_clients.delete(client)
    client.close unless client.closed?
  end
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
