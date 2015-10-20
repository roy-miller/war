require 'spec_helper'
require 'mock_war_socket_client'

describe WarClient do
  #let(:client) { WarClient.new }
  #let(:server) { WarServer.new }
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
    @client.ask_to_play
    expect(@client.unique_id).to eq 1
    expect(@client.socket.closed?).to be false
  end
end
