require 'pry'

class Check
end

# Class: DinnerClub
#
# Attributes:
# @roster - Hash: Keys are Diner's names. Values is the total
#                 money they have paid over all events.
# @log    - Hash: Keys are the date of the event, Values are
#                 Check object for that event.
class DinnerClub
  
  def initialize
    @roster = {}
    @log ={}
  end
  
  def add_member_to_club()
    
  end
end

class Diner
end


binding.pry
    