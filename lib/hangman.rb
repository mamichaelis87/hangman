require_relative 'game.rb'
require 'json'

def check_for_save
  puts "Would you like to save and quit?\n"\
       "Enter 'Y' to save or 'N' to keep playing."
  choice = gets.chomp.upcase
  until choice == 'Y' || choice == 'N'
    puts "Invalid input. Please enter 'turn' or 'save'"
    choice = gets.chomp.upcase
  end

  if choice == 'Y'
    return true
  elsif choice == 'N'
    return false
  else
    "technical difficulties. Goodbye."
  end
end

def save_game(game, file)
  game.to_json(file)
end



def start_game(game)
  puts "Welcome to hangman.  You will guess letters until you know\n"\
        "the entire secret word.  Once you guess six incorrect letters,\n"\
        "you will be dead. Good luck!"
  game.display_man_status
  game.display_word_status
  if check_for_save
    save_game(game, 'saved_game.json')
    return
  end
  until game.check_for_end
    game.take_turn
    if check_for_save
      save_game(game, 'saved_game.json')
      return
    end
  end
end

def play_game
  puts "Do you want to load your saved game, or start a new one?"
  puts "Enter 'L' for load or 'N' for new game."

  response = gets.chomp.upcase

  until response == 'L' || response == 'N'
    puts "Please enter 'L' to load your saved game, or 'N' to start a new one."
    response = gets.chomp.upcase
  end
  
  if response == 'L'
    game = Game.from_json('saved_game.json')
    start_game(game)
  elsif response == 'N'
    words = File.readlines('english_words.txt')
    words = words.map do |word|
      word.chop
    end

    secret_word = "hi"
    secret_word = words.sample until secret_word.length.between?(5,12) 
      

    game = Game.new(secret_word)
    start_game(game)
  else
    puts "Technical error, try again later."
  end
end


play_game

  



