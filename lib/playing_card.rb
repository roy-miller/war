class PlayingCard
  attr_accessor :suit, :rank

  # TODO smarter way to do this?
  CLUB = 'C'
  SPADE = 'S'
  DIAMOND = 'D'
  HEART = 'H'
  TWO = 2
  THREE = 3
  FOUR = 4
  FIVE = 5
  SIX = 6
  SEVEN = 7
  EIGHT = 8
  NINE = 9
  TEN = 10
  JACK = 11
  QUEEN = 12
  KING = 13
  ACE = 14

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end

  def ==(other)
    @rank == other.rank && @suit == other.suit
  end

  def eql?(other)
    self == other
  end
end
