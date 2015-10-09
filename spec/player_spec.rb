require 'spec_helper'

describe(Player) do
  describe('.new') do
    it 'creates a player with a name and no hand' do
      player = Player.new
      expect(player.name).to eq 'default'
      expect(player.hand).to be_empty
    end
  end

  describe('.add_card_to_hand') do
    it 'adds card to empty hand' do
      player = Player.new
      player.add_card_to_hand(PlayingCard.new(PlayingCard::HEART, PlayingCard::QUEEN))
      expect(player.hand.count).to eq 1
    end
    it 'adds card of same suit and different rank to hand' do
      player = Player.new
      player.add_card_to_hand(PlayingCard.new(PlayingCard::HEART, PlayingCard::QUEEN))
      player.add_card_to_hand(PlayingCard.new(PlayingCard::HEART, PlayingCard::SIX))
      expect(player.hand.count).to eq 2
    end
    it 'adds card of different suit and same rank to hand' do
      player = Player.new
      player.add_card_to_hand(PlayingCard.new(PlayingCard::HEART, PlayingCard::QUEEN))
      player.add_card_to_hand(PlayingCard.new(PlayingCard::CLUB, PlayingCard::QUEEN))
      expect(player.hand.count).to eq 2
    end
    it 'does not add duplicate card to hand' do
      player = Player.new
      player.hand << PlayingCard.new(PlayingCard::HEART, PlayingCard::QUEEN)
      player.add_card_to_hand(PlayingCard.new(PlayingCard::HEART, PlayingCard::QUEEN))
      expect(player.hand.count).to eq 1
    end
  end

  describe('.add_cards_toHand') do
    it 'adds collection of cards to hand' do
      player = Player.new
      cards_to_add = []
      cards_to_add << PlayingCard.new(PlayingCard::CLUB, PlayingCard::ACE)
      cards_to_add << PlayingCard.new(PlayingCard::DIAMOND, PlayingCard::TWO)
      player.add_cards_to_hand(cards_to_add)
      expect(player.hand.count).to eq 2
    end
  end

  describe('.play_card') do
    it 'plays top card' do
      player = Player.new
      expected_card = PlayingCard.new(PlayingCard::SPADE, PlayingCard::FIVE)
      player.add_card_to_hand(expected_card)
      actual_card = player.play_card
      expect(actual_card).to eq expected_card
    end
  end
end
