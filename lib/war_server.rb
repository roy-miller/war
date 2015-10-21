require 'socket'
require 'json'
require_relative './player.rb'
require_relative './game.rb'

class WarServer
  attr_accessor :port, :socket, :pending_clients, :clients, :game

  def initialize(port: 2000)
    @port = port
    @socket = TCPServer.open('localhost', port)
    @pending_clients = []
    @clients = {}
    @next_unique_id = 1
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
    client_socket = @socket.accept
    # TODO need a ClientConnection class, or similar?
    @pending_clients << { socket: client_socket, unique_id: @next_unique_id }
    response = JSON.dump({ unique_id: @next_unique_id,
                           message: 'Welcome to war! Connecting you with a partner' })
    client_socket.puts response
    puts "added client with id #{@next_unique_id}"
    @next_unique_id += 1
  end

  def run(client)
    puts "should be waiting for a game to form ..."
    game = make_game
    if game
      puts "made a game: #{game}"
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
    puts "pending clients: #{@pending_clients.count} -> #{@pending_clients}"
    if @pending_clients.count == 2
      puts "got 2 clients"
      player1 = get_player_for_game
      player2 = get_player_for_game

      game = Game.new
      game.add_player(player1)
      game.add_player(player2)
      games << game
      puts "added a game"
      game
    end
  end

  def get_player_for_game
    puts "getting player for game"
    client = @pending_clients.shift
    puts "client is #{client}"
    ask_for_name(client: client[:socket])
    player_name = get_name(client: client[:socket])
    puts "got the name: #{player_name}"
    Player.new(player_name)
  end

  def ask_for_name(client:)
    puts "asking for name ..."
    payload = { message: "Enter your name:" }
    client.puts(JSON.dump(payload))
    #send_output_to_clients(payload)
  end

  def get_name(client:)
    result = nil
    begin
      result = client.read_nonblock(1000).chomp
    rescue IO::WaitReadable
      IO.select([client])
      retry
    end
    result
  end

  def play_game(game)
    game.deal
    while !game.over?
      prompt_clients_for_round
      result = game.play_round # wait for player input
      send_result_to_clients(result)
      #congratulate_round_winner(game, result.winner)
    end
    congratulate_game_winner(game) # what is this "result"?
  end

  def prompt_clients_for_rounds
    #@clients.each do |player,client|
    #  payload = { message: 'Hit <Enter> to play a card ...' }
    #  client[:socket].puts JSON.dump(payload)
    #end
    payload = { message: 'Hit <Enter> to play a card ...' }
    send_output_to_clients(payload)
  end

  def send_output_to_clients(payload)
    @clients.each do |player,client|
      client[:socket].puts JSON.dump(payload)
    end
  end

  def receive_input_from_client(client)
    puts "client socket: #{client[:socket]}"
    result = nil
    begin
      result = client[:socket].read_nonblock(1000).chomp
    rescue IO::WaitReadable
      IO.select([client[:socket]])
      retry
    end
    JSON.parse(result, :symbolize_names => true)
  end

  def send_result_to_clients(result)
    #put uniqueid for client in the result?
    @clients.each do |player,client|
      client[:socket].puts JSON.dump(result.to_json)
    end
  end

  def stop
    @clients.each do |player, client|
      stop_connection(client: client)
    end
    @socket.close unless @socket.closed?
  end

  def stop_connection(client:)
    @pending_clients.delete(client)
    client[:socket].close unless client[:socket].closed?
  end
end
