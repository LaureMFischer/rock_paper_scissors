require 'spec_helper'
require_relative '../lib/game.rb'
require_relative '../lib/player.rb'

describe Game do
  describe '#initialize' do
    it 'assigns a strategy attribute if one is passed' do
      game = Game.new('favorite')
      expect(game.strategy).to eq 'favorite'
    end

    it 'defaults to the randomize strategy if strategy is not passed' do
      game = Game.new(nil)
      expect(game.strategy).to eq 'randomize'
    end

    it 'defaults to the randomize strategy if an invalid strategy is passed' do
      game = Game.new('fake_strategy')
      expect(game.strategy).to eq 'randomize'
    end
  end

  describe '#validate_player_choice' do
    it 'warns the player if they enter an invalid option' do
      game = Game.new('favorite')
      expect(STDOUT).to receive(:puts).with("Oops! You must choose between 'r', 'p', or 's'")
      game.validate_player_choice('q')
    end
  end

  describe '#determine_computer_choice' do
    context 'when the strategy is \'last\'' do
      before(:each) do
        @game = Game.new('last')
        @player = Player.new
      end

      it 'returns the winning choice compared with the player\'s last choice' do
        @player.update_move_history('r')
        expect(@game.determine_computer_choice(@player, 's')).to eq 'p'
      end

      it 'returns \'r\' arbitrarily if the player has no last choice yet' do
        expect(@game.determine_computer_choice(@player, 's')).to eq 'r'
      end
    end

    context 'when the strategy is \'favorite\'' do
      before(:each) do
        @game = Game.new('favorite')
        @player = Player.new
      end

      it 'returns the winning choice compared with the player\'s favorite choice' do
        @player.move_history = {'r' => 0,
                                'p' => 5,
                                's' => 1}
        expect(@game.determine_computer_choice(@player, 's')).to eq 's'
      end

      it 'returns \'r\' if the player has chosen all options equally' do
        @player.move_history = {'r' => 0,
                                'p' => 0,
                                's' => 0}
        expect(@game.determine_computer_choice(@player, 's')).to eq 'r'
      end
    end
  end

  describe '#determine_player_result' do
    before(:each) do
      @game = Game.new('favorite')
      @player = Player.new
    end

    it 'accurately reflects a player\'s loss' do
      expect(@game.determine_player_result(@player, 'r', 'p')).to eq 'loss'
      expect(@player.losses).to eq 1
    end

    it 'accurately reflects a tie' do
      expect(@game.determine_player_result(@player, 'r', 'r')).to eq 'tie'
      expect(@player.ties).to eq 1
    end

    it 'accurately reflects a player\'s win' do
      expect(@game.determine_player_result(@player, 's', 'p')).to eq 'win'
      expect(@player.wins).to eq 1
    end
  end

  describe '#display_messages' do
    before(:each) do
      @game = Game.new('favorite')
      @player = Player.new
    end

    it 'displays messages telling the player they lost' do
      @player.losses = 1
      expect(STDOUT).to receive(:puts).with("I chose r. I win!")
      expect(STDOUT).to receive(:puts).with("You won 0 times")
      expect(STDOUT).to receive(:puts).with("You lost 1 times")
      expect(STDOUT).to receive(:puts).with("We tied 0 times")
      @game.display_messages(@player, 'r', 'loss')
    end

    it 'displays messages telling the player they tied' do
      @player.ties = 1
      expect(STDOUT).to receive(:puts).with("I chose r. We tied!")
      expect(STDOUT).to receive(:puts).with("You won 0 times")
      expect(STDOUT).to receive(:puts).with("You lost 0 times")
      expect(STDOUT).to receive(:puts).with("We tied 1 times")
      @game.display_messages(@player, 'r', 'tie')
    end

    it 'displays messages telling the player they won' do
      @player.wins = 1
      expect(STDOUT).to receive(:puts).with("I chose r. You win!")
      expect(STDOUT).to receive(:puts).with("You won 1 times")
      expect(STDOUT).to receive(:puts).with("You lost 0 times")
      expect(STDOUT).to receive(:puts).with("We tied 0 times")
      @game.display_messages(@player, 'r', 'win')
    end
  end
end
