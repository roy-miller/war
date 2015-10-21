require_relative 'war_client.rb'

client = WarClient.new
client.connect
client.provide_name('Roy')
client.play_next_round
