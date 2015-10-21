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
    puts "server started"
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
    @next_unique_id += 1
  end

  def run(client)
    game = make_game
    if game
      #pair_clients_and_players(game)
      play_game(game)
      stop_connection(client: @clients[new_game.players.first])
      stop_connection(client: @clients[new_game.players.last])
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
    ask_for_name(client: client[:socket])
    player_name = get_name(client: client[:socket])
    player = Player.new(player_name)
    @clients[player] = client
    player
  end

  def ask_for_name(client:)
    payload = { message: "Enter your name:" }
    ready_to_send = JSON.dump(payload)
    client.puts(JSON.dump(ready_to_send))
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
      prompt_clients_for_round(game)
      wait_for_client_responses(game)
      result = game.play_round # wait for player input
      send_round_result_to_clients(game, result)
      #congratulate_round_winner(game, result.winner)
    end
    congratulate_game_winner(game) # what is this "result"?
  end

  def clients_for_game(game)
    game_clients = []
    game.players.each do |player|
      client_for_player = @clients[player]
      game_clients << client_for_player
    end
    game_clients
  end

  def prompt_clients_for_round(game)
    payload = { message: 'Hit <Enter> to play a card ...' }
    game_clients = clients_for_game(game)
    send_output_to_clients(payload, game_clients)
  end

  def wait_for_client_responses(game)
    responses = []
    until responses.count == 2
      input = receive_input_from_client
      responses << input
    end
  end

  def send_output_to_clients(payload, clients)
    clients.each do |client|
      client[:socket].puts JSON.dump(payload)
    end
  end

  def receive_input_from_client(client)
    result = nil
    begin
      result = client[:socket].read_nonblock(1000).chomp
    rescue IO::WaitReadable
      IO.select([client[:socket]])
      retry
    end
    input = JSON.parse(result, :symbolize_names => true)
    input
  end

  def send_round_result_to_clients(game, result)
    #put uniqueid for client in the result?
    game.players.each do |player|
      client_for_player = @clients[player]
      client_for_player[:socket].puts JSON.dump(result.to_json)
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
