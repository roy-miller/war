require 'spec_helper'
require 'war_server'
require 'mock_war_socket_client'

describe WarServer do

  context 'with server and active client' do
    before do
      @server = WarServer.new
      @client = MockWarSocketClient.new
      @client.start
      @server.accept
      @client.provide_input('player1')
    end

    after do
      @server.stop
    end

    it 'accepts a new client and gives it a unique id' do
      expect(@server.pending_clients.count).to eq 1
      expect(@server.pending_clients.first[:unique_id]).to eq 1
    end

    it 'asks player for name' do
      @server.ask_for_name(client: @server.pending_clients.first[:socket])
      expect(@client.output).to match /Enter your name/
    end

    it 'gets name from player' do
      @client.provide_input('player1')
      result = @server.get_name(client: @server.pending_clients.first[:socket])
      expect(result).to eq 'player1'
    end

    it 'does not make a game when there is only one player' do
      game = @server.make_game
      expect(game).to be_nil
    end

    context 'with a second client' do
      before do
        @client2 = MockWarSocketClient.new
        @client2.start
        @server.accept
        @client2.provide_input('player2')
      end

      it 'makes a game for two clients' do
        @client.provide_input('player1')
        @client2.provide_input('player2')
        @server.make_game
        expect(@server.games.count).to eq 1
        expect(@server.pending_clients.count).to eq 0
      end

      context 'with a game' do
        before do
          @game = Game.new
          @player1 = Player.new('player1')
          @player2 = Player.new('player2')
          @game.add_player(@player1)
          @game.add_player(@player2)
          @server.games << @game
          @server.clients[@player1] = @server.pending_clients.first
          @server.clients[@player2] = @server.pending_clients.last
        end

        it 'congratulates player1 when he wins a round' do
          @server.congratulate_round_winner(@game, @player1)
          expect(@client.output).to match /You won/
          expect(@client2.output).to match /You lost/
        end

        it 'congratulates player2 when he wins a round' do
          @server.congratulate_round_winner(@game, @player2)
          expect(@client.output).to match /You lost/
          expect(@client2.output).to match /You won/
        end

        it 'congratulates player2 when he wins a game' do
          @game.winner = @player2
          @server.congratulate_game_winner(@game)
          expect(@client.output).to match /You lost/
          expect(@client2.output).to match /You won/
        end
      end

      it 'allows multiple simultaneous games' do
        existing_player1 = Player.new('player1')
        existing_player2 = Player.new('player2')
        existing_game = Game.new
        existing_game.add_player(existing_player1)
        existing_game.add_player(existing_player2)
        @server.games << existing_game
        @server.make_game
        expect(@server.games.count).to eq 2
      end
    end
  end
end
