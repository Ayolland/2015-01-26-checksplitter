require 'pry'

class Checksplitter
  def initialize(prmtotal,prmguests)
    ##This class creates an object to assist in evenly splitting a check between a number of people. When defining a checksplitter object, input the bill total and the number of guests to split it between.
    @total = prmtotal
    @guests = prmguests.round
    @grat = 0.2
    @eachsub = @total / @guests
    puts "You will be splitting $" + @total.to_s + " evenly between " + @guests.to_s + " people."
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
    tiptotal = @total * @grat
    tipeach = (tiptotal / @guests).round(2)
    eachsub = (@eachsub.round(2))
    puts "Each guest should pay $" + eachsub.to_s + " to the balance, and $" + tipeach.to_s + " in gratuity,"
    puts "for a total of $" + (eachsub + tipeach).round(2).to_s + "."
  end
  
  binding.pry
  
end
    