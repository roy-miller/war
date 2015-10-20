require 'spec_helper'

describe RoundResult do

  context 'with a result' do
    let(:result) do
      winner = Player.new('winner')
      loser = Player.new('loser')
      cards_played = {}
      cards_played[winner] = [PlayingCard.new(rank: 'Q', suit: 'H')]
      cards_played[loser] = [PlayingCard.new(rank: '9', suit: 'C')]
      RoundResult.new(winner: Player.new('winner'), cards_played: cards_played)
    end

    describe '#to_json' do
        it 'returns JSON for result' do
          expected_json = { :winner => 'winner',
                            :cards_played => { :player1 => ['QH'], :player2 => ['9C'] }
                          }
          expect(result.to_json).to eq expected_json
        end
    end
  end

end
