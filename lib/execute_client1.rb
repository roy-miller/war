require_relative 'war_client.rb'

client = WarClient.new
client.connect
client.ask_to_play
client.provide_name('Roy')
client.play_game
