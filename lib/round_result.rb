class RoundResult
  def initialize(winner:, cards_played:)
    @winner = winner
    @cards_played = cards_played
  end

  def to_json
    { winner: @winner.name, cards_played: @cards_played }
  end
end
