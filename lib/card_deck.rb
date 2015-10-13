class CardDeck
  attr_reader :cards
  attr_accessor :ranks, :suits

  def initialize
    @cards = Array.new
    @suits = ['C','S','H','D']
    @ranks = ['1','2','3','4','5','6','7','8','9','10','J','Q','K']
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
