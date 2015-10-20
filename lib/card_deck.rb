require 'playing_card_constants'

class CardDeck
  include PlayingCardConstants

  attr_accessor :cards

  def initialize
    @suits = ['S','C','H','D']
    @ranks = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
    @cards = Array.new
    @suits.each do |suit|
      @ranks.each do |rank|
        @cards << PlayingCard.new(rank: rank, suit: suit)
      end
    end
  end

  def add(card)
    @cards << card
  end

  def remove(card)
    @cards.delete(card)
  end

  def shuffle
    @cards.shuffle!
  end

  def deal(card_count, players)
    players.each do |player|
      card_count.times do |i|
        card_to_deal = @cards.pop
        player.add_card_to_hand(card_to_deal)
      end
    end
  end

  def has_cards?
    !@cards.empty?
  end

  def card_count
    @cards.size
  end
end
