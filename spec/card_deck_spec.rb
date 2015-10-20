require 'spec_helper'

describe CardDeck do
  let(:deck) { CardDeck.new }

  describe '#new' do
      it 'has a full set of playing cards' do
        deck = CardDeck.new
        expect(deck.cards.count).to eq 52
      end
  end

  describe '#add' do
    it 'adds a card' do
      deck.add(PlayingCard.new(rank: 'rank', suit: 'suit'))
      expect(deck.cards.count).to eq 53
    end
  end

  describe '#remove' do
    it 'removes a card' do
      card = PlayingCard.new(rank: 'rank', suit: 'suit')
      deck.cards << card
      expect(deck.cards).to include card
      deck.remove(card)
      expect(deck.cards).not_to include card
    end
  end

  # TODO what's a better way to test this?
  describe '#shuffle' do
    it 'shuffles cards' do
      card1 = PlayingCard.new(rank: 'rank1', suit: 'suit1')
      card2 = PlayingCard.new(rank: 'rank2', suit: 'suit1')
      card3 = PlayingCard.new(rank: 'rank1', suit: 'suit2')
      card4 = PlayingCard.new(rank: 'rank2', suit: 'suit2')
      deck.add(card1)
      deck.add(card2)
      deck.add(card3)
      deck.add(card4)
      unshuffled_array = [card1, card2, card3, card4]

      deck.shuffle

      expect(deck.cards).not_to eq(unshuffled_array)
    end
  end

  describe '#deal' do
    it 'deals requested number of cards to each player' do
      player1 = Player.new('player1')
      player2 = Player.new('player2')

      deck.deal(26, [player1, player2])

      expect(deck.cards).to be_empty
      expect(player1.hand.count).to eq 26
      expect(player2.hand.count).to eq 26
    end
  end

  describe '#has_cards?' do
    context 'when deck has cards' do
      it 'should answer true when the deck has cards' do
        expect(deck.has_cards?).to be true
      end
    end
    context 'when deck is empty' do
      let(:deck) do
        deck = CardDeck.new
        deck.cards = []
        deck
      end
      it 'should answer false' do
        expect(deck.has_cards?).to be false
      end
    end
  end

  describe '#card_count' do
    context 'when deck is a full deck of playing cards' do
      it 'should answer the number of cards' do
        expect(deck.card_count).to eq 52
      end
    end
    context 'after dealing cards' do
      it 'should answer the number of cards remaining' do
        player = Player.new('playername')
        deck.deal(1, [player])
        expect(deck.card_count).to eq 51
      end
    end
  end
end
