class Game
  attr_reader :deck
  attr_accessor :players

  def initialize
    @deck = CardDeck.new
    suits = [PlayingCard::SPADE, PlayingCard::CLUB, PlayingCard::HEART, PlayingCard::DIAMOND]
    ranks = [PlayingCard::TWO, PlayingCard::THREE, PlayingCard::FOUR, PlayingCard::FIVE,
            PlayingCard::SIX, PlayingCard::SEVEN, PlayingCard::EIGHT, PlayingCard::NINE,
            PlayingCard::TEN, PlayingCard::JACK, PlayingCard::QUEEN, PlayingCard::KING,
            PlayingCard::ACE]
    suits.each do |suit|
      ranks.each do |rank|
        @deck.add(PlayingCard.new(suit, rank))
      end
    end
    @players = []
    @players << Player.new('player1')
    @players << Player.new('player2')
  end

  def play_round
    cards_played = {}
    @players.each do |player|
      cards_played[player] = []
      cards_played[player] << player.play_card
    end

    winner = nil
    if (cards_played.values.first.first.rank == cards_played.values.last.first.rank)
      winner = nil
    else
      winner = cards_played.key(cards_played.values.max_by { |x| x.last.rank })
    end

    puts "cards played = #{cards_played}"
    while winner.nil?
      winner = self.fight(cards_played)
    end

    cards_played.values.each do |cards|
      winner.add_cards_to_hand(cards)
    end

    winner
  end

  def fight(cards_played)
    @players.each do |player|
      cards_played[player] << player.play_card
      cards_played[player] << player.play_card
    end

    winner = nil
    if (cards_played.values.first.first.rank == cards_played.values.last.first.rank)
      winner = nil
    else
      winner = cards_played.key(cards_played.values.max_by { |x| x.first.rank })
    end

    winner
  end
end
