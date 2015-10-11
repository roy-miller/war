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

  def play_round(cards_played = [])
    card1 = @players.first.play_card
    card2 = @players.last.play_card
    cards_played.push(card1, card2)

    winner = nil
    if card1.rank > card2.rank
      winner = @players.first
      winner.add_cards_to_hand(cards_played)
    end
    if card2.rank > card1.rank
      winner = @players.last
      winner.add_cards_to_hand(cards_played)
    end
    if card1.rank == card2.rank
      war_card1 = @players.first.play_card
      war_card2 = @players.last.play_card
      cards_played.push(war_card1, war_card2)
      while !winner
        winner = self.play_round(cards_played)
      end
    end

    winner
  end
end
