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

  context 'with server' do
    before do
      @server = WarServer.new
    end

    after do
      @server.stop
    end

    it 'does not make a game for only one player' do
      expect(@server.games).to be_empty
    end

    it 'accepts client' do
      client = MockWarSocketClient.new
      client.start
      @server.accept
      expect(@server.pending_clients.count).to eq 1
    end

    it 'asks player for name' do
      client = MockWarSocketClient.new
      client.start
      @server.accept
      @server.ask_for_name(client: @server.pending_clients.first)
      expect(client.output).to match /Enter your name/
    end

    it 'gets name from player' do
      client = MockWarSocketClient.new
      client.start
      @server.accept
      client.provide_input('player1')
      result = @server.get_name(client: @server.pending_clients.first)
      expect(result).to eq 'player1'
    end

    it 'does not make a game when there is only one player' do
      client = MockWarSocketClient.new
      client.start
      @server.accept
      game = @server.make_game
      expect(game).to be_nil
    end

    it 'makes a game when there are two clients' do
      client1 = MockWarSocketClient.new
      client2 = MockWarSocketClient.new
      client1.start
      client2.start
      @server.accept
      @server.accept
      client1.provide_input('player1')
      client2.provide_input('player2')
      @server.make_game
      expect(@server.games.count).to eq 1
    end

    it 'congratulates player1 when he wins a round' do
      client1 = MockWarSocketClient.new
      client2 = MockWarSocketClient.new
      client1.start
      client2.start
      @server.accept
      @server.accept
      winner = Player.new('player1')
      loser = Player.new('player2')
      game = Game.new
      game.add_player(loser)
      game.add_player(winner)
      @server.games << game
      @server.clients[winner] = @server.pending_clients.first
      @server.clients[loser] = @server.pending_clients.last
      @server.congratulate_round_winner(game, winner)
      expect(client1.output).to match /You won/
      expect(client2.output).to match /You lost/
    end

    it 'congratulates player2 when he wins a round' do
      client1 = MockWarSocketClient.new
      client2 = MockWarSocketClient.new
      client1.start
      client2.start
      @server.accept
      @server.accept
      loser = Player.new('player1')
      winner = Player.new('player2')
      game = Game.new
      game.add_player(loser)
      game.add_player(winner)
      @server.games << game
      @server.clients[loser] = @server.pending_clients.first
      @server.clients[winner] = @server.pending_clients.last
      @server.congratulate_round_winner(game, winner)
      expect(client1.output).to match /You lost/
      expect(client2.output).to match /You won/
    end

    it 'congratulates player1 when he wins a game' do
      client1 = MockWarSocketClient.new
      client2 = MockWarSocketClient.new
      client1.start
      client2.start
      @server.accept
      @server.accept
      loser = Player.new('player1')
      winner = Player.new('player2')
      game = Game.new
      game.add_player(loser)
      game.add_player(winner)
      game.winner = winner
      @server.games << game
      @server.clients[loser] = @server.pending_clients.first
      @server.clients[winner] = @server.pending_clients.last
      @server.congratulate_game_winner(game)
      expect(client1.output).to match /You lost/
      expect(client2.output).to match /You won/
    end

    it 'allows multiple simultaneous games' do
      
    end
=begin
  end

  context 'with server and active client connections' do

    before :each do
      @server = WarServer.new
      @server.socket.listen(5)
      @client = MockWarSocketClient.new
      @client2 = MockWarSocketClient.new
      @client_socket = @server.socket.accept
      @client2_socket = @server.socket.accept
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

    context 'game is made' do
      before :each do
        @server.clients << @client_socket
        @server.clients << @client2_socket
        @client.provide_input("Player1")
        @client2.provide_input("Player2")
        @game = @server.make_game
      end

      describe '#congratulate_round_winner' do
        it 'congratulates player1 when he wins the round' do
          @server.congratulate_round_winner(@game.player1)
          expect(@client.output).to include "You won the round!"
          expect(@client2.output).to include "You lost the round"
        end
        it 'congratulates player1 when he wins the round' do
          @server.congratulate_round_winner(@game.player2)
          expect(@client.output).to include "You lost the round"
          expect(@client2.output).to include "You won the round!"
        end
      end

      describe '#congratulate_game_winner' do
        it 'congratulates player1 when he wins the game' do
          @server.congratulate_game_winner(@game.player1)
          expect(@client.output).to match(/You won the game!/)
          expect(@client2.output).to match(/You lost the game/)
        end
      end

    end
=end
  end
end
