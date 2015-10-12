require 'spec_helper'

describe PlayingCard do
  describe '#suit and .rank' do
      it 'has a suit and a rank' do
        card = PlayingCard.new(rank: PlayingCard::TWO, suit: PlayingCard::SPADE)
        expect(card.suit).to eq PlayingCard::SPADE
        expect(card.rank).to eq PlayingCard::TWO
      end
  end
end
