class CardDeck
  attr_reader :cards

  def initialize
    @cards = Array.new
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
end
