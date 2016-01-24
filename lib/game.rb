class Game
  attr_accessor :strategy
  # Map rock, paper, scissors choices to the moves that would beat them
  WINNING_PLAYS = {'r' => 'p',
                   'p' => 's',
                   's' => 'r'}

  VALID_STRATEGIES = ['favorite',
                      'last',
                      'randomize']
  # Map the player's result to the message the computer should display
  COMPUTER_RESULT_MESSAGES = {'win' => 'You win!',
                              'loss' => 'I win!',
                              'tie' => 'We tied!'}

  def initialize(strategy)
    @strategy = VALID_STRATEGIES.include?(strategy) ? strategy : 'randomize'
  end

  def play_a_round(player, choice)
    validate_player_choice(choice)
    computer_choice = determine_computer_choice(player, choice)
    player_result = determine_player_result(player, choice, computer_choice)
    player.update_move_history(choice)
    display_messages(player, computer_choice, player_result)
  end

  def validate_player_choice(choice)
    if !WINNING_PLAYS.keys.include?(choice)
      puts "Oops! You must choose between 'r', 'p', or 's'"
    end
  end

  def determine_computer_choice(player, choice)
    if strategy == 'favorite'
      favorite_move = player.get_favorite_move
      computer_choice = WINNING_PLAYS[favorite_move]
    elsif strategy == 'last'
      computer_choice = player.last_move ? WINNING_PLAYS[player.last_move] : 'r'
    else
      self.strategy = 'randomize'
      computer_choice = WINNING_PLAYS.keys.sample
    end
    computer_choice
  end

  def determine_player_result(player, choice, computer_choice)
    if WINNING_PLAYS[choice] == computer_choice
      player.losses += 1
      player_result = 'loss'
    elsif choice == computer_choice
      player.ties += 1
      player_result = 'tie'
    else
      player.wins += 1
      player_result = 'win'
    end
    player_result
  end

  def display_messages(player, computer_choice, player_result)
    puts "I chose #{computer_choice}. #{COMPUTER_RESULT_MESSAGES[player_result]}"
    puts "You won #{player.wins} times"
    puts "You lost #{player.losses} times"
    puts "We tied #{player.ties} times"
  end
end
