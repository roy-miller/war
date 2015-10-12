require 'spec_helper'

describe(Game) do
  describe('#new') do
    it 'creates a game with two players and a full deck' do
      game = Game.new
      expect(game.deck.cards.count).to eq 52
      expect(game.players.count).to eq 2
    end
  end

  describe('#play_round') do
    it 'declares player1 the winner when its card rank is higher, adds cards to player1' do
      game = Game.new
      player1 = Player.new('player1')
      card1 = PlayingCard.new(rank: PlayingCard::TEN, suit: PlayingCard::SPADE)
      player1.hand = [card1]
      player2 = Player.new('player2')
      card2 = PlayingCard.new(rank: PlayingCard::FOUR, suit: PlayingCard::HEART)
      player2.hand = [card2]
      game.players = [player1, player2]

      winner = game.play_round

      expect(winner.name).to eq 'player1'
      expect(winner.hand).to include(card1, card2)
    end
  end

  describe('#play_round') do
    it 'declares player2 the winner when its card rank is higher, adds cards to player2' do
      game = Game.new
      player1 = Player.new('player1')
      card1 = PlayingCard.new(rank: PlayingCard::TEN, suit: PlayingCard::SPADE)
      player1.hand = [card1]
      player2 = Player.new('player2')
      card2 = PlayingCard.new(rank: PlayingCard::QUEEN, suit: PlayingCard::HEART)
      player2.hand = [card2]
      game.players = [player1, player2]

      winner = game.play_round

      expect(winner.name).to eq 'player2'
      expect(winner.hand).to include(card1, card2)
    end
  end

  describe('#play_round') do
    it 'declares war when ranks are the same, adds cards to winner' do
      game = Game.new
      player1 = Player.new('player1')
      player2 = Player.new('player2')
      card1 = PlayingCard.new(rank: PlayingCard::KING, suit: PlayingCard::CLUB)
      card2 = PlayingCard.new(rank: PlayingCard::TWO, suit: PlayingCard::SPADE)
      card3 = PlayingCard.new(rank: PlayingCard::JACK, suit: PlayingCard::SPADE)
      card4 = PlayingCard.new(rank: PlayingCard::NINE, suit: PlayingCard::DIAMOND)
      card5 = PlayingCard.new(rank: PlayingCard::EIGHT, suit: PlayingCard::CLUB)
      card6 = PlayingCard.new(rank: PlayingCard::JACK, suit: PlayingCard::HEART)
      player1.hand = [card1, card2, card3]
      player2.hand = [card4, card5, card6]
      game.players = [player1, player2]

      winner = game.play_round

      expect(winner.name).to eq 'player1'
      expect(winner.hand).to include(card1, card2, card3, card4, card5, card6)
    end

    it 'declares multiple wars when ranks are the same, adds cards to winner' do
      game = Game.new
      player1 = Player.new('player1')
      player2 = Player.new('player2')
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
      player1.hand = [card1, card2, card3, card4, card5]
      player2.hand = [card6, card7, card8, card9, card10]
      game.players = [player1, player2]

      winner = game.play_round

      expect(winner.name).to eq 'player2'
      expect(winner.hand).to include(card1, card2, card3, card4, card5,
                                     card6, card7, card8, card9, card10)
    end
  end
end
