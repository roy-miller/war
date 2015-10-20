require 'spec_helper'

describe(Player) do
  let(:player) { Player.new }

  describe('#new') do
    it 'creates a player with a name and no hand' do
      expect(player.name).to eq 'default'
      expect(player.hand).to be_empty
    end
  end

  describe('#add_card_to_hand') do
    it 'adds card to empty hand' do
      added_card = PlayingCard.new(rank: 'Q', suit: 'H')
      player.add_card_to_hand(added_card)
      expect(player.hand).to match([added_card])
    end
    it 'adds card to bottom of non-empty hand' do
      existing_card = PlayingCard.new(rank: 'Q', suit: 'H')
      added_card = PlayingCard.new(rank: '2', suit: 'S')
      player.hand << (existing_card)
      player.add_card_to_hand(added_card)
      expect(player.hand).to match([added_card, existing_card])
    end
  end

  describe('#add_cards_to_hand') do
    it 'adds collection of cards to bottom of hand' do
      card1 = PlayingCard.new(rank: '4', suit: 'S')
      card2 = PlayingCard.new(rank: 'A', suit: 'C')
      card3 = PlayingCard.new(rank: 'A', suit: 'D')
      player.hand << card1
      cards_to_add = [card2, card3]
      player.add_cards_to_hand(cards_to_add)
      expect(player.hand).to match([card3, card2, card1])
    end
  end

  describe('#play_card') do
    it 'plays top card' do
      card1 = PlayingCard.new(rank: 'Q', suit: 'S')
      card2 = PlayingCard.new(rank: '5', suit: 'S')
      top_card = PlayingCard.new(rank: '10', suit: 'H')
      player.hand << card1
      player.hand << card2
      player.hand << top_card
      actual_card = player.play_card
      expect(actual_card).to eq top_card
      expect(player.hand).to match([card1, card2])
    end
  end

  describe('#out_of_cards?') do
    it 'answers true when player has no cards' do
      expect(player.out_of_cards?).to be true
    end

    it 'answers false when player has cards' do
      player.hand << PlayingCard.new(rank: 'irrelevant', suit: 'irrelevant')
      expect(player.out_of_cards?).to be false
    end
  end
end
