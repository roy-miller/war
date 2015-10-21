require 'spec_helper'
require 'war_server'
require 'mock_war_socket_client'
require 'json'

describe WarServer do

  context 'with server' do
    before do
      @server = WarServer.new
    end

    after do
      @server.stop
    end

    context 'with no active clients' do
      before do
        @client = MockWarSocketClient.new
        @client.start
        @server.accept
      end

      it 'does not let a client play without a unique id' do
        input = JSON.dump({input:"\n"})
        @client.provide_input(input)
        player = @server.get_player_for_game
        expect(player).to be_nil
      end

      it 'lets a client play with a unique id' do
        input = JSON.dump({id: 1, input:"\n"})
        @client.provide_input(input)
        player = @server.get_player_for_game
        expect(player).to be_nil
      end
    end

    context 'with active client' do
      before do
        #@server = WarServer.new
        @client = MockWarSocketClient.new
        @client.start
        @server.accept
        @client.output # consume welcome message
        @client.provide_input(JSON.dump({id: 1, input: 'player1'}))
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

      it 'does not make a game when there is only one player' do
        game = @server.make_game
        expect(game).to be_nil
      end

      context 'with a second client' do
        before do
          @client2 = MockWarSocketClient.new
          @client2.start
          @server.accept
          @client2.output # consume welcome message
          @client2.provide_input(JSON.dump({id: 1, input: 'player2'}))
        end

        it 'makes a game for two clients' do
          @server.make_game
          expect(@server.games.count).to eq 1
          expect(@server.pending_clients.count).to eq 0
        end

        context 'with a game' do
          before do
            @game = Game.new
            @winner = Player.new('player1')
            @loser = Player.new('player2')
            @game.add_player(@winner)
            @game.add_player(@loser)
            @server.games << @game
            @server.clients[@winner] = @server.pending_clients.first
            @server.clients[@loser] = @server.pending_clients.last
          end

          it 'sends game round results to clients' do
            @server.clients[@winner] = @server.pending_clients.first
            @server.clients[@loser] = @server.pending_clients.last
            cards_played = {
                              player1: [PlayingCard.new(rank: 'J', suit: 'H')],
                              player2: [PlayingCard.new(rank: '2', suit: 'C')]
                           }
            result = RoundResult.new(winner: @winner, loser: @loser, cards_played: cards_played)
            @server.send_round_result_to_clients(@game, result)
            result_json_string = JSON.dump(result.to_json)
            expect(@client.output).to include result_json_string
            expect(@client2.output).to include result_json_string
          end
        end
      end
    end
  end
end
