require 'spec_helper'
require_relative '../player.rb'

describe Player do
  before(:each) do
    @player = Player.new
  end
  describe '#initialize' do
    it 'assigns the default attributes' do
      expect(@player.wins).to eq 0
      expect(@player.losses).to eq 0
      expect(@player.ties).to eq 0
      expect(@player.last_move).to eq nil
      expect(@player.move_history['r']).to eq 0
      expect(@player.move_history['p']).to eq 0
      expect(@player.move_history['s']).to eq 0
    end
  end

  describe '#get_favorite_move' do
    it 'returns the move that the player has used the greatest number of times' do
      @player.move_history['p'] = 5
      @player.move_history['s'] = 3
      expect(@player.get_favorite_move).to eq 'p'
    end

    it 'returns \'s\' if the player has no move history' do
      expect(@player.get_favorite_move).to eq 's'
    end
  end

  describe '#update_move_history' do
    it 'updates the player\'s last move and move counts' do
      @player.update_move_history('r')
      expect(@player.last_move).to eq 'r'
      expect(@player.move_history['r']).to eq 1
      expect(@player.move_history['p']).to eq 0
      expect(@player.move_history['s']).to eq 0
    end
  end
end
