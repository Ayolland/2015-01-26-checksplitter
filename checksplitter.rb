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
    if @settled == :no
      gratuity = tip * 0.01
      gratuity = 0.01 if gratuity < 0.01
    end
  end
  
  #
  #This method determines the total including tip.
  def calc_total
    (@total_after_tax * @gratuity) + @total_after_tax
  end
  
  #FINISH THIS DOC LATER
  # This method will assign shares based on how much each member ordered.
  def split_individually
    total_pre_tax = 0.0
    @members_attending.each do |member_name, each_pre_tax|
     total_pre_tax += each_pre_tax
    end
    @members_attending.each do |member_name, each_pre_tax|
      @members_share[member_name] = (each_pre_tax / total_pre_tax).round(2)
    end
    return @members_share
  end
  
  ##FINISH THIS DOC LATER
  #THis method will assign shares evenly, regardless of what each person ordered.
  def split_evenly
    @members_attending.each do|member_name, each_pre_tax|
      @members_share[member_name] = (1.0 / @number_of_guests).round(2)
    end
    return (1.0 / @number_of_guests).round(2)
  end
  
  #FINISH THIS DOC LATER
  #This method will set one member's shares to 100% and all others to 0%
  def all_on(very_nice_person)
    @members_attending.each do |member_name, each_pre_tax|
      if member_name == very_nice_person
        @members_share[member_name] = 1
      else
        @members_share[member_name] = 0
      end
    end
    return very_nice_person
  end
  
  #FINISH THIS DOC LATER
  # This method should use the Check object to determine how much each member should pay, and create a hash of that.
  def settle
    settlement = {}
    @members_share.each do |name, share|
      settlement[name] = (calc_total * share)
    end
    @settled = :yes
    return settlement
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
  #This method creates a new diner in the roster. 
  def add_member_to_club(name_of_new_diner)
    @roster[name_of_new_diner] = 0
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
  # This method should add a settled check to the log.
  def add_check_to_log(check_object, description)
    if check_object.settled == :yes
      @log[description] = check_object.settle
      check_object.settle.each do |name, paid|
        puts check_object.settle[name]
        @roster[name] = 0 if @roster[name] == nil
        @roster[name] += paid.to_f
      end
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
pizza = Check.new(36.50)
superpals.add_member_to_check(pizza,'Batman',12.12)
superpals.add_member_to_check(pizza,'Barbara',10.0)
superpals.add_member_to_check(pizza,'Dick',8.92)
pizza.split_individually
pizza.settle
superpals.add_check_to_log(pizza,'01-30 Went to fancy pizza with kids.')
ice_cream = Check.new(22.07)
superpals.add_member_to_check(ice_cream,'Batman',2.0)
superpals.add_member_to_check(ice_cream,'Barbara',10.0)
superpals.add_member_to_check(ice_cream,'Dick',1000.00)
superpals.add_member_to_check(ice_cream,'Clark',0.5)
ice_cream.split_evenly
ice_cream.settle
superpals.add_check_to_log(ice_cream,'01-30 Got ice cream with Clark after.')
scotch = Check.new (150.00)
superpals.add_member_to_check(scotch,'Batman',50.00)
superpals.add_member_to_check(scotch,'Clark',50.00)
superpals.add_member_to_check(scotch,'Diana',50.00)
scotch.all_on('Batman')
scotch.settle
superpals.add_check_to_log(scotch,'Bought a round for the gang.')
puts superpals.log
binding.pry
    