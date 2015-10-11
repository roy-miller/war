class Player
  attr_accessor :name
  attr_accessor :hand

  def initialize(name = 'default')
    @name = name
    @hand = []
  end

  def add_card_to_hand(card)
    @hand.unshift card
  end

  def add_cards_to_hand(cards)
    cards.each do |card|
      self.add_card_to_hand(card)
    end
  end

  def play_card
    @hand.pop
  end

  def out_of_cards?
    @hand.empty?
  end
end
