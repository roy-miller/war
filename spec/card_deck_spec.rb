require 'spec_helper'

describe CardDeck do
  describe "#new" do
      it "has no cards" do
        deck = CardDeck.new
        expect(deck.cards.count).to eq 0
      end
  end

  describe "#add" do
    it "adds a card" do
      deck = CardDeck.new
      deck.add(PlayingCard.new('suit','rank'))
      expect(deck.cards.count).to eq 1
    end
  end

  describe "#remove" do
    it "removes a card" do
      deck = CardDeck.new
      card = PlayingCard.new('suit','rank')
      deck.add(card)
      deck.remove(card)
      expect(deck.cards.count).to eq 0
    end
  end

  describe "#shuffle" do
    it "shuffles cards" do
      deck = CardDeck.new
      card1 = PlayingCard.new('suit1','rank1')
      card2 = PlayingCard.new('suit1','rank2')
      card3 = PlayingCard.new('suit2','rank1')
      card4 = PlayingCard.new('suit2','rank2')
      deck.add(card1)
      deck.add(card2)
      deck.add(card3)
      deck.add(card4)
      expected_array = [card3, card1, card4, card2]

      deck.shuffle

      expect(deck.cards).to match_array(expected_array)
    end
  end

  describe "#deal" do
    it "deals correct number of cards to players" do
      deck = CardDeck.new
      suits = [PlayingCard::SPADE, PlayingCard::CLUB, PlayingCard::HEART, PlayingCard::DIAMOND]
      ranks = [PlayingCard::TWO, PlayingCard::THREE, PlayingCard::FOUR, PlayingCard::FIVE,
              PlayingCard::SIX, PlayingCard::SEVEN, PlayingCard::EIGHT, PlayingCard::NINE,
              PlayingCard::TEN, PlayingCard::JACK, PlayingCard::QUEEN, PlayingCard::KING,
              PlayingCard::ACE]
      suits.each do |suit|
        ranks.each do |rank|
          deck.add(PlayingCard.new(suit, rank))
        end
      end
      player1 = Player.new('player1')
      player2 = Player.new('player2')

      deck.deal(26, [player1, player2])

      expect(deck.cards.count).to eq 0
      expect(player1.hand.count).to eq 26
      expect(player2.hand.count).to eq 26
    end
  end

  describe '#has_cards?' do
    it 'should answer false when deck is empty' do
      deck = CardDeck.new
      expect(deck.has_cards?).to be false
    end
    it 'should answer true when the deck has cards' do
      deck = CardDeck.new
      deck.cards << PlayingCard.new('irrelevantsuit', 'irrelevantrank')
      expect(deck.has_cards?).to be true
    end
  end
end
