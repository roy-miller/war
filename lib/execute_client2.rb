require_relative 'war_client.rb'

client = WarClient.new
client.connect
client.ask_to_play
client.provide_name('Joe')
client.play_game
