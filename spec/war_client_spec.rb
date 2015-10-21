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

  # client waits for server instructions
  # client hits enter to tell server it's ok to play
  # server waits for BOTH clients to do that
  # server plays round and returns result to clients
  # clients wait for message from server that game is over

  it 'receives game round results from server and shows them' do
    # winner = Player.new('player1')
    # loser = Player.new('player2')
    # cards_played = {
    #                   player1: [PlayingCard.new(rank: 'J', suit: 'H')],
    #                   player2: [PlayingCard.new(rank: '2', suit: 'C')]
    #                }
    # result = RoundResult.new(winner, loser, cards_played)
    # @server.send_reult_to_clients(result)
    # response = @client.receive

  end
end
