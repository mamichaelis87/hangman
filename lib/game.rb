require_relative 'stages_of_death.rb'
# require_relative 'game_logic.rb'
require 'json'

class Game
  # include GameLogic
  include StagesOfDeath
  attr_reader :progress, :secret_word, :current_guess, :stage_of_death

  def initialize(secret_word = "hello", progress = [], stage_of_death = 0, 
    current_guess = "1", previous_guesses = [])
    @secret_word = secret_word
    @progress = progress
    @stage_of_death = stage_of_death
    @current_guess = current_guess
    @previous_guesses = previous_guesses
  end

  def take_turn
    puts "Your previous guesses were #{@previous_guesses}"
    get_guess
    update_guesses
    update_progress
    puts "Your current state is:"
    display_man_status
    puts "Your current progress is:"
    display_word_status
  end

  # def play_game
  #   puts "Welcome to hangman.  You will guess letters until you know\n"\
  #         "the entire secret word.  Once you guess six incorrect letters,\n"\
  #         "you will be dead. Good luck!"
  #   display_word_status
  #   if check_for_save
  #     save_game
  #     return
  #   until check_for_end
  #     take_turn
  #     if check_for_save
  #       save_game
  #       return
  #     end
  #   end
  # end

  def take_turn
    puts "Your previous guesses were #{@previous_guesses}"
    get_guess
    update_guesses
    update_progress
    puts "Your current state is:"
    display_man_status
    puts "Your current progress is:"
    display_word_status
  end

  # def check_for_save
  #   puts "Would you like to save and quit?\n"\
  #        "Enter 'Y' to save or 'N' to keep playing."
  #   choice = gets.chomp.upcase
  #   until choice == 'Y' || choice == 'N'
  #     puts "Invalid input. Please enter 'turn' or 'save'"
  #     choice = gets.chomp.upcase
  #   end

  #   if choice == 'Y'
  #     return true
  #   elsif choice == 'N'
  #     return false
  #   else
  #     "technical difficulties. Goodbye."
  #   end
  # end

  def update_progress
    secret_word.split("").each_with_index do |secret_letter, index|
      if secret_letter == @current_guess then @progress[index] = @current_guess 
      end
    end
    
    unless @secret_word.split("").include?(@current_guess)
      @stage_of_death += 1
    end

  end

  def get_guess
    puts "Guess a single letter."
    @current_guess = gets.chomp.downcase
    until @current_guess.length == 1 && @current_guess.match?(/[a-z]/)
      puts "Guess a single letter."
      @current_guess = gets.chomp.downcase 
      unless @current_guess.length == 1 && @current_guess.match?(/[a-z]/)
        puts "That is not a valid guess."
      end
    end
    if @previous_guesses.include?(@current_guess)
      puts "you already guessed that letter."
      get_guess 
      end
  end

  def display_man_status
    case @stage_of_death
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
      complete
    else 
      puts "We are experiencing technical difficulties... please stand by."
    end
  end

  def display_word_status
    if @previous_guesses == []
      @secret_word.length.times {@progress.push("_")}
    end
    puts @progress.join(" ")
  end

  def update_guesses
    @previous_guesses.push(@current_guess)
  end

  def check_for_end
    if @stage_of_death == 6
      puts "You have died, better luck in the next life.\n"\
            "The word was #{@secret_word}"
      return true
    elsif @progress.join("") == @secret_word
      puts "You found the secret word. The hangman will be disappointed"
      return true
    else  
      return false
    end
  end

  def to_json(file)
    File.write(file, JSON.dump({
      :secret_word => @secret_word,
      :progress => @progress, 
      :stage_of_death => @stage_of_death,
      :current_guess => @current_guess, 
      :previous_guesses => @previous_guesses
    }))
    end

  def self.from_json(file)
    data = JSON.load(File.read(file))
    self.new(data["secret_word"], data["progress"], data["stage_of_death"],
              data["current_guess"], data["previous_guesses"])
    end

end
