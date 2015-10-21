require 'spec_helper'
require 'mock_war_socket_client'

def capture_stdout(&blk)
  old = $stdout
  $stdout = fake = StringIO.new
  blk.call
  fake.string
ensure
  $stdout = old
end

def provide_input(text)
  @client.socket.puts(text)
end

describe WarClient do
  before do
    @server = WarServer.new
    @client = WarClient.new
    @client.connect
    @server.accept
  end
  after do
    @server.stop
  end

  it 'connects to server and gets unique id' do
    result = capture_stdout { @client.ask_to_play }
    expect(@client.unique_id).to eq 1
    expect(@client.socket.closed?).to be false
    expect(result).to match /Welcome/
  end

  it 'sends user name to server' do
    @client.provide_name('username')
    result = @server.receive_input_from_client(@server.pending_clients.first)
    expect(result[:input]).to match /username/
  end

  it 'plays a game round' do
    @client.play_next_round
    result = @server.receive_input_from_client(@server.pending_clients.first)
    expect(result[:input]).to match /\n/
  end

  # client waits for server instructions
  # client hits enter to tell server it's ok to play
  # server waits for BOTH clients to do that
  # server plays round and returns result to clients
  # clients wait for message from server that game is over

  # it 'receives game round results from server and shows them' do
  #   winner = Player.new('player1')
  #   loser = Player.new('player2')
  #   cards_played = {
  #                     player1: [PlayingCard.new(rank: 'J', suit: 'H')],
  #                     player2: [PlayingCard.new(rank: '2', suit: 'C')]
  #                  }
  #   result = RoundResult.new(winner: winner, loser: loser, cards_played: cards_played)
  #   @server.clients[winner] = @server.pending_clients.first
  #   @server.clients[loser] = @server.pending_clients.last
  #   @server.send_result_to_clients(result)
  #   #@client.play_game
  #   result = capture_stdout { @client.play_game }
  #   expect(result).to match /something/
  # end
end
