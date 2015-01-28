require 'pry'

class Check
  
  attr_reader :total_after_tax, :members_attending, :members_share
  attr_accessor :gratuity, :settled, :number_of_guests
  
  def initialize(total_after_tax_temp)
    @total_after_tax = total_after_tax_temp
    @members_attending = {} #this should be pushed from the DiningClub class
    @members_share = {} #this will be show what percentage of the bill/tip each member should cover
    @settled = :no #This marks the check as currently active and able to be modified.
    @number_of_guests = 0 #this will be added to as the DiningClub object adds members
    @gratuity = 0.2 #Gratuity is set to a default of twenty percent.
  end
  
  ##FINISH THIS DOC LATER
  #This method will take a 0-100 value and covert it to a percentage, with a minimum of .1
  def set_gratuity(tip)
    gratuity = tip * 0.01
    gratuity = 0.01 if gratuity < 0.01
  end
  
  #FINISH THIS DOC LATER
  #
  def split_individually
    total_pre_tax = 0.0
    @members_attending.each do |member_name, each_pre_tax|
     total_pre_tax += each_pre_tax
    end
    @members_attending.each do |member_name, each_pre_tax|
    @members_share[member_name] = (each_pre_tax / total_pre_tax).round(2)
    #puts @members_share[member_name]
    end
    #return total_pre_tax
  end
  
  ##FINISH THIS DOC LATER
  #THis method will split the bill evenly, regardless of what each person ordered.
  def split_evenly
    @members_attending.each do|member_name, each_pre_tax|
      
    end
  end
  
  #FINISH THIS DOC LATER
  #This method will set one member's share to 100% and all others to 0%
  def all_on(very_nice_person)
  end
    
  #FINISH THIS DOC LATER
  #This method should use @members_share to determine how much each member should pay
  def split_check
  end
  
end

# Class: DinnerClub
#
# Attributes:
# @roster - Hash: Keys are member's names. Values are Diner objects.
# @log    - Hash: Keys are the date of the event, Values are
#                 Check object for that event.
class DinnerClub
  
   attr_reader :roster, :log
  
  def initialize
    @roster = {}
    @log ={}

  end

  # FINISH THIS DOC LATER
  #This method creates a new Diner object and adds it into @roster.
  def add_member_to_club(name_of_new_diner)
    @roster[name_of_new_diner] = Diner.new(name_of_new_diner)
  end
  
  #FINISH THIS DOC LATER
  # This method should push a member's name and the amount they spent pre-tax to the Check object.
  def add_member_to_check(name_of_check,member_name,individual_amount_pretax)
    if name_of_check.settled == :no
    name_of_check.members_attending[member_name] = individual_amount_pretax
    name_of_check.number_of_guests += 1
    end
  end
  
  #FINISH THIS DOC LATER
  # This method should use the Check object to determine how much each member should pay, add that to their balance in the Diner object, and mark that Check as settled.
  def settle_check(check_object)
    check_object.settled = :yes #that's all for now
  end
  
  #FINISH THIS DOC LATER
  # This method should add a settled check to the log.
  def add_check_to_log(check_object,date)
    if (check_object.settled == :yes) && (@log[date] == nil)
      @log[date] = check_object
    end
  end
end

#this class should have a name, a balance, and a log.
class Diner
  
  attr_reader :name, :dinner_log, :member_balance
  
  def initialize(real_name)
    @name = real_name #
    @dinner_log = {} #A hash where date is the key, and Check objects are values.
    @member_balance = 0 #To be added to with each event they attend.
  end
  
end

superpals = DinnerClub.new
superpals.add_member_to_club('Batman')
pizza = Check.new(350.55)
superpals.add_member_to_check(pizza,'Batman',5.50)
superpals.add_member_to_check(pizza,'Sally',10.0)
superpals.add_member_to_check(pizza,'Mom',8.92)
superpals.settle_check(pizza)
superpals.add_check_to_log(pizza,'now')
binding.pry
    