require_relative './playing_card.rb'
require_relative './player.rb'

player1 = Player.new('player1')
player1.hand = [PlayingCard.new(PlayingCard::SPADE, PlayingCard::TEN)]
card_played = player1.play_card
puts card_played.rank
