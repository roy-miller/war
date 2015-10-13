require 'spec_helper'

describe(Game) do
  let(:game) do
    game = Game.new
    game.players << Player.new('player1')
    game.players << Player.new('player2')
    game
  end
  let(:higher_rank_card) { PlayingCard.new(rank: PlayingCard::QUEEN, suit: PlayingCard::SPADE) }
  let(:lower_rank_card) { PlayingCard.new(rank: PlayingCard::FOUR, suit: PlayingCard::HEART) }

  describe('#new') do
    it 'creates a game with a full deck' do
      game = Game.new
      expect(game.deck.cards.count).to eq 52
    end
  end

  describe('#play_round') do
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
        card1 = PlayingCard.new(rank: PlayingCard::KING, suit: PlayingCard::CLUB)
        card2 = PlayingCard.new(rank: PlayingCard::TWO, suit: PlayingCard::SPADE)
        card3 = PlayingCard.new(rank: PlayingCard::JACK, suit: PlayingCard::SPADE)
        card4 = PlayingCard.new(rank: PlayingCard::NINE, suit: PlayingCard::DIAMOND)
        card5 = PlayingCard.new(rank: PlayingCard::EIGHT, suit: PlayingCard::CLUB)
        card6 = PlayingCard.new(rank: PlayingCard::JACK, suit: PlayingCard::HEART)
        game.players.first.hand = [card1, card2, card3]
        game.players.last.hand = [card4, card5, card6]

        winner = game.play_round

        expect(winner.name).to eq 'player1'
        expect(winner.hand).to include(card1, card2, card3, card4, card5, card6)
      end
    end
    it 'declares multiple wars, adds cards to winner' do
      card1 = PlayingCard.new(rank: PlayingCard::SIX, suit: PlayingCard::HEART)
      card2 = PlayingCard.new(rank: PlayingCard::SIX, suit: PlayingCard::SPADE)
      card3 = PlayingCard.new(rank: PlayingCard::KING, suit: PlayingCard::CLUB)
      card4 = PlayingCard.new(rank: PlayingCard::THREE, suit: PlayingCard::CLUB)
      card5 = PlayingCard.new(rank: PlayingCard::JACK, suit: PlayingCard::SPADE)
      card6 = PlayingCard.new(rank: PlayingCard::TEN, suit: PlayingCard::DIAMOND)
      card7 = PlayingCard.new(rank: PlayingCard::ACE, suit: PlayingCard::SPADE)
      card8 = PlayingCard.new(rank: PlayingCard::KING, suit: PlayingCard::CLUB)
      card9 = PlayingCard.new(rank: PlayingCard::FIVE, suit: PlayingCard::DIAMOND)
      card10 = PlayingCard.new(rank: PlayingCard::JACK, suit: PlayingCard::HEART)
      game.players.first.hand = [card1, card2, card3, card4, card5]
      game.players.last.hand = [card6, card7, card8, card9, card10]

      winner = game.play_round

      expect(winner.name).to eq 'player2'
      expect(winner.hand).to include(card1, card2, card3, card4, card5,
                                     card6, card7, card8, card9, card10)
    end
  end
end
