require 'pry'

class Checksplitter
  def initialize(param_total,dinner_club_name)
    @total = param_total.round(2)
    @guests = 0
    @members = []
    @grat = 0.2
    @club = dinner_club_name
    @settled = :no
    #puts "You will be splitting $" + @total.to_s + " evenly between " + @guests.to_s + " people."
  end
  
  attr_reader :total, :guests, :grat, :members, :club, :split, :tipeach, :tiptotal, :settled
  
  def addguest(member_name)
    if settled == :no
      @members.push(member_name)
      @guests += 1
    end
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
    if settled == :no
      @grat = t * 0.01
    end
  end
  
  def split
    eachsub + tipeach
  end
  
  def settle
    @members.each do |member_name|
      @club.roster[member_name] += split
    end
    @settled = :yes
  end
end

class DinnerClub
  
  def initialize
  @roster = {}
  @log ={}
  end
  
  attr_reader :roster, :log
  
  def add_member(member_name)
    @roster[member_name] = 0.0
  end
  
  def settle_and_log(checksplitter_name,date)
    checksplitter_name.settle
    @log[date] = checksplitter_name
  end
  
end


coolkids = DinnerClub.new
coolkids.add_member('Diane')
coolkids.add_member('Ross')
coolkids.add_member('Fozzy')
puts coolkids.roster
thai = Checksplitter.new(200,coolkids)
thai.addguest('Diane')
thai.addguest('Ross')
puts thai.members
thai.set_grat(26)
coolkids.settle_and_log(thai,'1-30-2015')
puts coolkids.roster
thai.settle
coolkids.roster

binding.pry
    