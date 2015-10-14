require 'spec_helper'
require 'war_server'
require 'mock_war_socket_client'

def capture_stdout(&block)
  old = $stdout
  $stdout = fake = StringIO.new
  block.call
  fake.string
ensure
  $stdout = old
end

describe WarServer do

  before :each do
    @server = WarServer.new
    @server.socket.listen(5)
    @client = MockWarSocketClient.new
    @client_socket = @server.socket.accept
  end

  after :each do
    @client_socket.close
    @server.socket.close
  end

  describe '#initialize' do
    it 'creates a server with a socket' do
      server = WarServer.new(port: 2000)
      expect(server).to be_a WarServer
      expect(server.socket).to be_a TCPServer
      server.socket.close
    end
  end

  describe '#pair_players' do
    context 'not two players yet' do
      it 'welcomes player, adds to pending clients, and does not start game' do
        @server.pair_players(@client_socket)
        expect(@client.output).to include "Welcome to war!"
        expect(@server.pending_clients.count).to eq 1
      end
    end
    context 'two players' do
      it 'welcomes player, adds to clients, empties pending clients, and starts game' do
        @server.pair_players(@client_socket)
        @server.socket.listen(5)
        client2 = MockWarSocketClient.new
        client2_connection = @server.socket.accept
        @server.pair_players(client2_connection)
        client2_connection.close
        expect(@server.pending_clients.count).to eq 0
        expect(@server.clients.count).to eq 2
      end
    end
  end

  describe '#ask_for_name' do
    it 'prompts player for name' do
      @server.ask_for_name(client: @client_socket)
      expect(@client.output).to eq "Enter your name:\n"
    end
  end

  # describe '#get_name' do
  #   it 'gets name from a player' do
  #   end
  # end

  # describe '#stop' do
  #   it 'stops main thread and all clients' do
  #     server = WarServer.new(2005)
  #     client1 = MockWarSocketClient.new(2005)
  #     client2 = MockWarSocketClient.new(2005)
  #     server.clients << client1.socket
  #     server.clients << client2.socket
  #     server.stop
  #     expect(client1.socket.closed?).to be true
  #     expect(client2.socket.closed?).to be true
  #   end
  # end

end
