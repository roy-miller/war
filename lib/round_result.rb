class RoundResult
  attr_accessor :winner, :cards_played

  def initialize(winner:, cards_played:)
    @winner = winner
    @cards_played = cards_played
  end

  def had_winner
    !@winner.nil?
  end

  def to_json
    { winner: @winner.name,
      cards_played: {
        player1: @cards_played['player1'].map { |card| card.to_s },
        player2: @cards_played['player2'].map { |card| card.to_s }
      }
    }
  end
end
