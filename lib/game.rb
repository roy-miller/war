require_relative './card_deck.rb'
require_relative './playing_card.rb'
require_relative './playing_card_constants.rb'

class Game
  include PlayingCardConstants

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

  def play_round(cards_played = [])
    puts "playing round: #{cards_played}"
    return declare_game_winner if over?

    card1 = @players.first.play_card
    card2 = @players.last.play_card
    cards_played.push(card1, card2)

    winner = nil
    if card1.rank_value > card2.rank_value
      puts "card1:#{card1.rank} > card2:#{card2.rank}"
      winner = @players.first
      winner.add_cards_to_hand(cards_played)
    elsif card2.rank_value > card1.rank_value
      puts "card2:#{card2.rank} > card1:#{card1.rank}"
      winner = @players.last
      winner.add_cards_to_hand(cards_played)
    elsif card1.rank_value == card2.rank_value
      puts "card1:#{card1.rank} == card2:#{card2.rank}"
      return declare_game_winner if over?
      war_card1 = @players.first.play_card
      return declare_game_winner if over?
      war_card2 = @players.last.play_card
      return declare_game_winner if over?
      cards_played.push(war_card1, war_card2)
      while !winner
        winner = play_round(cards_played)
      end
    elsif over?
      winner = declare_game_winner
    end

    winner
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
