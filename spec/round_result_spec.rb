require 'spec_helper'

describe RoundResult do

  context 'with a result' do
    let(:result) do
      player1 = Player.new('player1')
      player2 = Player.new('player2')
      cards_played = {}
      cards_played['player1'] = [PlayingCard.new(rank: 'Q', suit: 'H'),
                                 PlayingCard.new(rank: '6', suit: 'C'),
                                 PlayingCard.new(rank: 'A', suit: 'S')]
      cards_played['player2'] = [PlayingCard.new(rank: 'Q', suit: 'D'),
                                 PlayingCard.new(rank: '2', suit: 'S'),
                                 PlayingCard.new(rank: '7', suit: 'C')]
      RoundResult.new(winner: Player.new('winner'), cards_played: cards_played)
    end

    describe '#had_winner' do
      it 'answers true if there was a winner' do
        expect(result.had_winner).to be true
      end
      it 'answers false if there was no winner' do
        result.winner = nil
        expect(result.had_winner).to be false
      end
    end

    describe '#to_json' do
      it 'returns JSON for result' do
        expected_json = { :winner => 'winner',
                          :cards_played => {
                            :player1 => ['QH','6C','AS'],
                            :player2 => ['QD','2S','7C']
                          }
                        }
        expect(result.to_json).to eq expected_json
      end
    end
  end
end
