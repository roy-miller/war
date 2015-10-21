require_relative './card_deck.rb'
require_relative './playing_card.rb'

class Game
  attr_reader :deck
  attr_accessor :players
  attr_accessor :winner, :loser

  def initialize
    @deck = CardDeck.new
    @players = []
    @winner
    @loser
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
    if over?
      declare_game_winner
      return build_result(winner: @winner, loser: @loser, cards_played: cards_played)
    end

    card1 = @players.first.play_card
    card2 = @players.last.play_card
    cards_played[:player1].push(card1)
    cards_played[:player2].push(card2)

    winner = nil
    loser = nil
    if card1.rank_value > card2.rank_value
      winner = @players.first
      loser = @players.last
      [cards_played[:player1],cards_played[:player2]].each do |cards|
        winner.add_cards_to_hand(cards)
      end
    elsif card2.rank_value > card1.rank_value
      winner = @players.last
      loser = @players.first
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
        loser = result.loser
      end
    elsif over?
      winner, loser = declare_game_winner
    end

    build_result(winner: winner, loser: loser, cards_played: cards_played)
  end

  def build_result(winner:, loser:, cards_played:)
    RoundResult.new(winner: winner,
                    loser: loser,
                    cards_played: {
                      player1: cards_played[:player1],
                      player2: cards_played[:player2]
                    })
  end

  def declare_game_winner
    if player1.out_of_cards?
      @winner = player2
      @loser = player1
    end
    if player2.out_of_cards?
      @winner = player1
      @loser = player2
    end
    [@winner, @loser]
  end

  def over?
    player1.out_of_cards? || player2.out_of_cards?
  end
end
