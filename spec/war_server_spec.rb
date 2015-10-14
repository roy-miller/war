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

  describe '#initialize' do
    it 'creates a server with a socket' do
      server = WarServer.new(port: 2000)
      expect(server).to be_a WarServer
      expect(server.socket).to be_a TCPServer
      server.socket.close
    end
  end

  context 'with server and active client connection' do

    before :each do
      @server = WarServer.new
      @server.socket.listen(5)
      @client = MockWarSocketClient.new
      @client_socket = @server.socket.accept
    end

    after :each do
      @client_socket.close unless @client_socket.closed?
      @server.socket.close unless @server.socket.closed?
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

    describe '#get_name' do
      it 'gets player name' do
        @client.provide_input('Somebody')
        result = @server.get_name(client: @client_socket)
        expect(result).to include "Somebody"
      end
    end

    describe '#stop_connection' do
      it 'stops an open connection, removes from clients and pending clients' do
        @server.pending_clients << @client_socket
        @server.clients << @client_socket
        expect(@server.pending_clients.include?(@client_socket)).to eq true
        expect(@server.clients.include?(@client_socket)).to eq true
        @server.stop_connection(client: @client_socket)
        expect(@client_socket.closed?).to be true
        expect(@server.pending_clients.include?(@client_socket)).to eq false
        expect(@server.clients.include?(@client_socket)).to eq false
      end

      it 'handles a closed connection without an exception, removes from clients and pending clients' do
        @server.pending_clients << @client_socket
        @server.clients << @client_socket
        expect(@server.pending_clients.include?(@client_socket)).to eq true
        expect(@server.clients.include?(@client_socket)).to eq true
        @client_socket.close
        @server.stop_connection(client: @client_socket)
        expect(@client_socket.closed?).to be true
        expect(@server.pending_clients.include?(@client_socket)).to eq false
        expect(@server.clients.include?(@client_socket)).to eq false
      end
    end

    describe '#stop' do
      it 'stops the server, closes all connections, removes them' do
        client2_socket = MockWarSocketClient.new.socket
        @server.pending_clients << @client_socket
        @server.pending_clients << client2_socket
        @server.clients << @client_socket
        @server.clients << client2_socket
        expect(@client_socket.closed?).to be false
        expect(client2_socket.closed?).to be false
        expect(@server.pending_clients.count).to eq 2
        expect(@server.clients.count).to eq 2
        @server.stop
        expect(@client_socket.closed?).to be true
        expect(client2_socket.closed?).to be true
        expect(@server.socket.closed?).to be true
        expect(@server.pending_clients.count).to eq 0
        expect(@server.clients.count).to eq 0
      end
    end

    # describe '#play_game' do
    #   it 'creates a game with two players and plays game' do
    #
    #   end
    # end
  end
end
