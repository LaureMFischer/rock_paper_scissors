class Player
  attr_accessor :wins, :losses, :ties, :last_move, :move_history

  def initialize
    @wins = 0
    @losses = 0
    @ties = 0
    @last_move = nil
    @move_history = {'r' => 0,
                     'p' => 0,
                     's' => 0}
  end

  def get_favorite_move
    move_history.sort_by { |k, v| v }.last.first
  end

  def update_move_history(choice)
    self.last_move = choice
    move_history[choice] += 1
  end
end
