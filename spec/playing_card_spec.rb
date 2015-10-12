require 'spec_helper'

describe PlayingCard do
  describe '#suit and #rank' do
      it 'has a suit and a rank' do
        card = PlayingCard.new(rank: PlayingCard::TWO, suit: PlayingCard::SPADE)
        expect(card.suit).to eq PlayingCard::SPADE
        expect(card.rank).to eq PlayingCard::TWO
      end
  end

  describe '#==' do
    it 'answers true when two cards have same values' do
      card1 = PlayingCard.new(rank: 'rank', suit: 'suit')
      card2 = PlayingCard.new(rank: 'rank', suit: 'suit')
      expect(card1 == card2).to be true
    end

    it 'answers false when two cards do not have same values' do
      card1 = PlayingCard.new(rank: 'rank', suit: 'suit')
      card2 = PlayingCard.new(rank: 'differentrank', suit: 'suit')
      expect(card1 == card2).to be false

      card2 = PlayingCard.new(rank: 'rank', suit: 'differentsuit')
      expect(card1 == card2).to be false
    end
  end

  describe '#eql?' do
    it 'answers true when two cards have same values' do
      card1 = PlayingCard.new(rank: 'rank', suit: 'suit')
      card2 = PlayingCard.new(rank: 'rank', suit: 'suit')
      expect(card1.eql?(card2)).to be true
    end
    it 'answers false when two cards do not have same values' do
      card1 = PlayingCard.new(rank: 'rank', suit: 'suit')
      card2 = PlayingCard.new(rank: 'differentrank', suit: 'suit')
      expect(card1.eql?(card2)).to be false

      card2 = PlayingCard.new(rank: 'rank', suit: 'differentsuit')
      expect(card1.eql?(card2)).to be false
    end
  end
end
