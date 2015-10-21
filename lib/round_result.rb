class RoundResult
  attr_accessor :winner, :loser, :cards_played

  def initialize(winner:, loser:, cards_played:)
    @winner = winner
    @loser = loser
    @cards_played = cards_played
  end

  def had_winner
    !@winner.nil?
  end

  def to_json
    { winner: @winner.name,
      loser: @loser.name,
      cards_played: {
        player1: @cards_played[:player1].map { |card| card.to_s },
        player2: @cards_played[:player2].map { |card| card.to_s }
      }
    }
  end
end
