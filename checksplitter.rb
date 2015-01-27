require 'pry'

class Checksplitter
  def initialize(param_total,dinner_club_name)
    ##This class creates an object to assist in evenly splitting a check between a number of people. When defining a checksplitter object, input the bill total and the number of guests to split it between.
    @total = param_total.round(2)
    @guests = 0
    @members = []
    @grat = 0.2
    @club = dinner_club_name
    #puts "You will be splitting $" + @total.to_s + " evenly between " + @guests.to_s + " people."
  end
  
  attr_reader :total, :guests, :grat, :members, :club, :split
  
  def addguest(member_name)
    @members.push(member_name)
    @guests += 1
  end
  
  def eachsub
    (@total / @guests).round(2)
  end
  
  def tiptotal
    @total * @grat
  end
  
  def tipeach
  (tiptotal / guests).round(2)
  end
  
  def set_grat(t)
    @grat = t / 100
  #  if @grat < 0.15
  #  puts "That bad, huh?"
  #  puts "You have set a gratuity of %" + t.to_s + "." 
  #  puts "Please remember: 20% is considered customary for good service."
  end
  
  def split
  #  puts "Each guest should pay $" + eachsub.to_s + " to the balance, and $" + tipeach.to_s + " in gratuity,"
  #  puts "for a total of $" + (eachsub + tipeach).to_s + "."
  eachsub + tipeach
  end
  
  def settle
    @members.each do |member_name|
      @club.roster[member_name] += split
  end
end
end

class DinnerClub
  
  def initialize
  @roster = {}
  end
  
  attr_reader :roster
  
  def add_member(member_name)
    @roster[member_name] = 0.0
  end
  
end


coolkids = DinnerClub.new
coolkids.add_member('Diane')
coolkids.add_member('Ross')
coolkids.add_member('Fozzy')
puts coolkids.roster
Thai = Checksplitter.new(200,coolkids)
Thai.addguest('Diane')
Thai.addguest('Ross')
puts Thai.members
Thai.set_grat(26)
Thai.settle
puts coolkids.roster

binding.pry
    