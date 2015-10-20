require_relative './card_deck.rb'
require_relative './playing_card.rb'

class Game
  attr_reader :deck
  attr_accessor :players
  attr_accessor :winner

  def initialize
    @deck = CardDeck.new
    @players = []
    @winner
  end

  def add_player(player)
    @players << player
  end

  def player1
    @players.first
  end

  def player2
    @players.last
  end

  def deal
    @deck.shuffle
    @deck.deal(26, @players)
  end

  def play_round(cards_played = {player1: [], player2: []})
    return declare_game_winner if over?

    card1 = @players.first.play_card
    card2 = @players.last.play_card
    cards_played[:player1].push(card1)
    cards_played[:player2].push(card2)

    winner = nil
    if card1.rank_value > card2.rank_value
      winner = @players.first
      [cards_played[:player1],cards_played[:player2]].each do |cards|
        winner.add_cards_to_hand(cards)
      end
    elsif card2.rank_value > card1.rank_value
      winner = @players.last
      [cards_played[:player1],cards_played[:player2]].each do |cards|
        winner.add_cards_to_hand(cards)
      end
    elsif card1.rank_value == card2.rank_value
      return declare_game_winner if over?
      war_card1 = @players.first.play_card
      return declare_game_winner if over?
      war_card2 = @players.last.play_card
      return declare_game_winner if over?
      cards_played[:player1].push(war_card1)
      cards_played[:player2].push(war_card2)
      while !winner
        result = play_round(cards_played)
        winner = result.winner
      end
    elsif over?
      winner = declare_game_winner
    end

    RoundResult.new(winner: winner, cards_played: {
      player1: cards_played[:player1],
      player2: cards_played[:player2]
    })
  end

  def declare_game_winner
    @winner = player2 if player1.out_of_cards?
    @winner = player1 if player2.out_of_cards?
    @winner
  end

  def over?
    player1.out_of_cards? || player2.out_of_cards?
  end
end
