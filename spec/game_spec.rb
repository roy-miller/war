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
      card1 = PlayingCard.new(PlayingCard::SPADE, PlayingCard::TEN)
      player1.hand = [card1]
      player2 = Player.new('player2')
      card2 = PlayingCard.new(PlayingCard::HEART, PlayingCard::FOUR)
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
      card1 = PlayingCard.new(PlayingCard::SPADE, PlayingCard::TEN)
      player1.hand = [card1]
      player2 = Player.new('player2')
      card2 = PlayingCard.new(PlayingCard::HEART, PlayingCard::QUEEN)
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
      card1 = PlayingCard.new(PlayingCard::CLUB, PlayingCard::KING)
      card2 = PlayingCard.new(PlayingCard::SPADE, PlayingCard::TWO)
      card3 = PlayingCard.new(PlayingCard::SPADE, PlayingCard::JACK)
      card4 = PlayingCard.new(PlayingCard::DIAMOND, PlayingCard::NINE)
      card5 = PlayingCard.new(PlayingCard::CLUB, PlayingCard::EIGHT)
      card6 = PlayingCard.new(PlayingCard::HEART, PlayingCard::JACK)
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
      card1 = PlayingCard.new(PlayingCard::HEART, PlayingCard::SIX)
      card2 = PlayingCard.new(PlayingCard::SPADE, PlayingCard::SIX)
      card3 = PlayingCard.new(PlayingCard::CLUB, PlayingCard::KING)
      card4 = PlayingCard.new(PlayingCard::CLUB, PlayingCard::THREE)
      card5 = PlayingCard.new(PlayingCard::SPADE, PlayingCard::JACK)
      card6 = PlayingCard.new(PlayingCard::DIAMOND, PlayingCard::TEN)
      card7 = PlayingCard.new(PlayingCard::SPADE, PlayingCard::ACE)
      card8 = PlayingCard.new(PlayingCard::CLUB, PlayingCard::KING)
      card9 = PlayingCard.new(PlayingCard::DIAMOND, PlayingCard::FIVE)
      card10 = PlayingCard.new(PlayingCard::HEART, PlayingCard::JACK)
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
