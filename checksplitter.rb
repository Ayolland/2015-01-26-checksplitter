require 'pry'

class Checksplitter
  def initialize(prmtotal,prmguests)
    ##This class creates an object to assist in evenly splitting a check between a number of people. When defining a checksplitter object, input the bill total and the number of guests to split it between.
    @total = prmtotal.round(2)
    @guests = prmguests.round
    @grat = 0.2
    puts "You will be splitting $" + @total.to_s + " evenly between " + @guests.to_s + " people."
  end
  
  attr_reader :total, :guests, :grat
  
  def eachsub
    (@total / @guests).round(2)
  end
  
  def tiptotal
    total * grat
  end
  
  def tipeach
    tipeach = (tiptotal / guests).round(2)
  end
  
  def set_grat(t)
    @grat = t / 100
    if @grat < 0.15
      puts "That bad, huh?"
    end
    puts "You have set a gratuity of %" + t.to_s + "." 
    puts "Please remember: 20% is considered customary for good service."
  end
  
  def split
    puts "Each guest should pay $" + eachsub.to_s + " to the balance, and $" + tipeach.to_s + " in gratuity,"
    puts "for a total of $" + (eachsub + tipeach).to_s + "."
  end
  
end


binding.pry
    