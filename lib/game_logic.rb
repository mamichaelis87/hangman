require_relative 'stages_of_death.rb'

module GameLogic
  include StagesOfDeath
  
  def update_progress(secret_word, current_guess, progress, stage_of_death)
    secret_word.split("").each_with_index do |secret_letter, index|
      if secret_letter == current_guess then progress[index] = current_guess 
      end
    end
    
    unless secret_word.split(" ").include?(current_guess)
      stage_of_death += 1
    end

  end

  def get_guess(current_guess)
    until current_guess.length == 1 && current_guess.match?(/[a-z]/)
      puts "Guess a single letter."
      current_guess = gets.chomp.downcase 
      unless current_guess.length == 1 && current_guess.match?(/[a-z]/)
        puts "That is not a valid guess."
      end
    end
    
  end

  def display_man_status(stage_of_death)
    case stage_of_death
    when 0
      not_started
    when 1
      one
    when 2
      two
    when 3
      three
    when 4
      four
    when 5
      five 
    when 6
      six
    else 
      puts "We are experiencing technical difficulties... please stand by."
    end
  end

  def display_word_status(progress)
    puts progress.join(" ")
  end

  def update_guesses(current_guess, previous_guesses)
    while previous_guesses.include?(current_guess)
      puts "you already guessed that letter."
      get_guess 
      end
    previous_guesses.push(current_guess)
  end

  def check_for_end(stage_of_death, secret_word, progress)
    if stage_of_death == 6
      puts "You have died, better luck in the next life."
      return true
    elsif progress.join("") == secret_word
      puts "You found the secret word. The hangman will be disappointed"
      return true
    else  
      return false
    end
  end

    

end


