require_relative 'lib/game'
require_relative 'lib/player'

new_game = Game.new(ARGV[0].to_s)
new_player = Player.new

while true
  puts "Type 'r', 'p' or 's'"
  puts "Type 'Done!' to quit"
  choice = STDIN.gets.chomp.to_s
  if !choice.include?('Done!')
    new_game.play_a_round(new_player, choice)
  else
    abort('Bye!')
  end
end
