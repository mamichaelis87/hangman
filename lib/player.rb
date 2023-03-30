require_relative 'stages_of_death.rb'

class Player
  include StagesOfDeath

  def initialize(name)
    @name = name
  end
end