require 'spec_helper'

describe Game do
  include PlayingCardConstants
  let(:thing) { joe = CONSTANT1; joe }
  let(:game) do
    game = Game.new
    game.players << Player.new('player1')
    game.players << Player.new('player2')
    game
  end
  let(:higher_rank_card) { PlayingCard.new(rank: 'Q', suit: 'S') }
  let(:lower_rank_card) { PlayingCard.new(rank: '4', suit: 'H') }

  describe '#new' do
    it 'creates a game with a deck of playing cards and no players' do
      game = Game.new
      expect(game.deck.cards.count).to eq 52
      expect(game.players).to be_empty
    end
  end

  describe '#add_player' do
    it 'adds player' do
      game = Game.new
      game.add_player(Player.new('playername'))
      expect(game.players.count).to eq 1
    end
  end

  context 'in a game with players' do
    let(:player1) { Player.new('player1') }
    let(:player2) { Player.new('player2') }
    let(:game) do
      game = Game.new
      game.players << player1
      game.players << player2
      game
    end

    describe '#player1' do
      it 'answers first player' do
        expect(game.player1).to eq player1
      end
    end

    describe '#player2' do
      it 'answers second player' do
        expect(game.player2).to eq player2
      end
    end

    describe '#deal' do
      it 'deals cards to players' do
        game.deal
        expect(player1.hand.count).to eq 26
        expect(player2.hand.count).to eq 26
      end
    end

    describe '#play_round' do
      context 'when player1 card ranks higher' do
        it 'declares player1 the winner, adds cards to player1' do
          game.players.first.hand = [higher_rank_card]
          game.players.last.hand = [lower_rank_card]
          winner = game.play_round
          expect(winner.name).to eq 'player1'
          expect(winner.hand).to include(higher_rank_card, lower_rank_card)
        end
      end
      context 'when player2 card ranks higher' do
        it 'declares player2 the winner when its card rank is higher, adds cards to player2' do
          game.players.first.hand = [lower_rank_card]
          game.players.last.hand = [higher_rank_card]
          winner = game.play_round
          expect(winner.name).to eq 'player2'
          expect(winner.hand).to include(lower_rank_card, higher_rank_card)
        end
      end
      context 'when ranks are the same' do
        it 'declares war, adds cards to winner' do
          card1 = PlayingCard.new(rank: 'K', suit: 'C')
          card2 = PlayingCard.new(rank: '2', suit: 'S')
          card3 = PlayingCard.new(rank: 'J', suit: 'S')
          card4 = PlayingCard.new(rank: '9', suit: 'D')
          card5 = PlayingCard.new(rank: '8', suit: 'C')
          card6 = PlayingCard.new(rank: 'J', suit: 'H')
          game.players.first.hand = [card1, card2, card3]
          game.players.last.hand = [card4, card5, card6]

          winner = game.play_round

          expect(winner.name).to eq 'player1'
          expect(winner.hand).to include(card1, card2, card3, card4, card5, card6)
        end
      end
      it 'declares multiple wars, adds cards to winner' do
        card1 = PlayingCard.new(rank: '6', suit: 'H')
        card2 = PlayingCard.new(rank: '6', suit: 'S')
        card3 = PlayingCard.new(rank: 'K', suit: 'C')
        card4 = PlayingCard.new(rank: '3', suit: 'C')
        card5 = PlayingCard.new(rank: 'J', suit: 'S')
        card6 = PlayingCard.new(rank: '10', suit: 'D')
        card7 = PlayingCard.new(rank: 'A', suit: 'S')
        card8 = PlayingCard.new(rank: 'K', suit: 'C')
        card9 = PlayingCard.new(rank: '5', suit: 'D')
        card10 = PlayingCard.new(rank: 'J', suit: 'H')
        game.players.first.hand = [card1, card2, card3, card4, card5]
        game.players.last.hand = [card6, card7, card8, card9, card10]

        winner = game.play_round

        expect(winner.name).to eq 'player2'
        expect(winner.hand).to include(card1, card2, card3, card4, card5,
                                       card6, card7, card8, card9, card10)
      end
      it 'does not play if the game is over' do
        game.players.first.hand = [PlayingCard.new(rank: '6', suit: 'H')]
        game.players.last.hand = []
        winner = game.play_round
        expect(winner).to be game.player1

        game.players.first.hand = []
        game.players.last.hand = [PlayingCard.new(rank: '6', suit: 'H')]
        winner = game.play_round
        expect(winner).to be game.player2
      end
    end

    describe '#over?' do
      it 'answers true when player1 is out of cards' do
        game.player1.hand = []
        expect(game.over?).to be true
      end
      it 'answers true when player2 is out of cards' do
        game.player2.hand = []
        expect(game.over?).to be true
      end
      it 'answers false when both players have cards' do
        game.player1.hand = [PlayingCard.new(rank: 'rank', suit: 'suit')]
        game.player2.hand = [PlayingCard.new(rank: 'rank', suit: 'suit')]
        expect(game.over?).to be false
      end
    end

    describe '#declare_game_winner' do
      it 'declares winner' do

      end
    end
  end
end
