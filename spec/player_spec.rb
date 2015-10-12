require 'spec_helper'

describe(Player) do
  describe('#new') do
    it 'creates a player with a name and no hand' do
      player = Player.new
      expect(player.name).to eq 'default'
      expect(player.hand).to be_empty
    end
  end

  describe('#add_card_to_hand') do
    it 'adds card to empty hand' do
      player = Player.new
      added_card = PlayingCard.new(rank: PlayingCard::QUEEN, suit: PlayingCard::HEART)
      player.add_card_to_hand(added_card)
      expect(player.hand).to match([added_card])
    end
    it 'adds card to bottom of non-empty hand' do
      player = Player.new
      existing_card = PlayingCard.new(rank: PlayingCard::QUEEN, suit: PlayingCard::HEART)
      added_card = PlayingCard.new(rank: PlayingCard::TWO, suit: PlayingCard::SPADE)
      player.hand << (existing_card)
      player.add_card_to_hand(added_card)
      expect(player.hand).to match([added_card, existing_card])
    end
  end

  describe('#add_cards_to_hand') do
    it 'adds collection of cards to bottom of hand' do
      player = Player.new
      card1 = PlayingCard.new(rank: PlayingCard::FOUR, suit: PlayingCard::SPADE)
      card2 = PlayingCard.new(rank: PlayingCard::ACE, suit: PlayingCard::CLUB)
      card3 = PlayingCard.new(rank: PlayingCard::ACE, suit: PlayingCard::DIAMOND)
      player.hand << card1
      cards_to_add = [card2, card3]
      player.add_cards_to_hand(cards_to_add)
      expect(player.hand).to match([card3, card2, card1])
    end
  end

  describe('#play_card') do
    it 'plays top card' do
      player = Player.new
      card1 = PlayingCard.new(rank: PlayingCard::QUEEN, suit: PlayingCard::SPADE)
      card2 = PlayingCard.new(rank: PlayingCard::FIVE, suit: PlayingCard::SPADE)
      top_card = PlayingCard.new(rank: PlayingCard::TEN, suit: PlayingCard::HEART)
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
      player = Player.new
      expect(player.out_of_cards?).to be true
    end

    it 'answers false when player has cards' do
      player = Player.new
      player.hand << PlayingCard.new(rank: 'irrelevant', suit: 'irrelevant')
      expect(player.out_of_cards?).to be false
    end
  end
end
