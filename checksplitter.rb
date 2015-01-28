require 'pry'

# Class: Check (previously checksplitter.)
#
# This class represents a check that needs to be split by one of three methods by the members of a DinnerCLub.
#
# Attributes:
# @total_after_tax   - The total value of the check when presented.
# @members_attending - A hash filled by the DiningClub class, keys are member names, 
#                      values are the amount each member ordered for this check.
# @members_share     - A hash, keys are names, values are the percentage of the total
#                      bill the member will end up paying.
# @settled           - This marks the check as active and able to be modified.
# @number_of_guests  - Total number of guests the check will be split between.
# @gratuity          - Gratuity, set to a default of twenty percent.
#
# Public Methods:
# #set_gratuity
# #calc_total
# #split_individually
# #split_evenly
# #all_on()
# #settle

class Check
  
  attr_reader :total_after_tax, :members_attending, :members_share, :gratuity, :settled
  attr_accessor :number_of_guests
  
  def initialize(total_after_tax_temp)
    @total_after_tax = total_after_tax_temp
    @members_attending = {} 
    @members_share = {} 
    @settled = :no 
    @number_of_guests = 0 
    @gratuity = 0.2 
  end
  
# Public: #set_gratuity
# Takes a percentage and converts it to a decimal, with a minimum of 0.1
#
# Parameters:
# tip - the new gratuity in percent.
#
# Returns: 
# @gratuity after any changes
#
# State Changes:
# Sets @gratuity to a value selected by the user, no lower than 0.1
  
  def set_gratuity(tip)
    if @settled == :no
      @gratuity = tip * 0.01
      @gratuity = 0.1 if @gratuity < 0.1
    end
    return @gratuity
  end
  
# Private: #calc_total
# Calculates the total bill including gratuity.
#
# Returns: 
# total bill plus tip

  def calc_total
    (@total_after_tax * @gratuity) + @total_after_tax
  end
  
# Public: #split_individually
# Assigns shares based on how much each member ordered.
#
# Returns: 
# @members_share
#
# State Changes:
# fills @members_share with member names and shares using @members_attending.
  
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
  
# Public: #split_individually
# Assigns shares evenly, regardless of what each person ordered.
#
# Returns: 
# float equal to each member's share
#
# State Changes:
# fills @members_share with member names and shares using @members_attending.
  
  def split_evenly
    @members_attending.each do|member_name, each_pre_tax|
      @members_share[member_name] = (1.0 / @number_of_guests).round(2)
    end
    return (1.0 / @number_of_guests).round(2)
  end
  
# Public: #split_individually
# Sets one member's shares to 100% and all others to 0%
#
# Returns: 
# Key for the member with the 100 share
#
# State Changes:
# fills @members_share with member names and shares using @members_attending.
  
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
  
# Public: #settle
# Uses @members_share and #calc_total to create a hash of each member's payment.
#
# Returns: 
# a hash where keys are member names and values are amounts paid.
#
# State Changes:
# Sets @settled to yes to prevent further changes.
  
  def settle
    settlement = {}
    @members_share.each do |name, share|
      settlement[name] = (calc_total * share).round(2)
    end
    @settled = :yes
    return settlement
  end
  
end

# Class: DinnerClub
#
# This class represents a group of diners tracking their expenditures when they eat together.
#
# Attributes:
# @roster - Hash: Keys are member's names. Values are the total spent by that member.
# @log    - Hash: Keys are the date of the event, Values are settlement hashes.
#
# Public Methods:
# #add_member_to_check
# #add_check_to_log


class DinnerClub
  
   attr_reader :roster, :log
  
  def initialize
    @roster = {}
    @log ={}
  end
  
# Public: #add_member_to_check
# Adds a member to a check object to determine how much they owe.
#
# Parameters:
# name_of_check             - the check object the method is adding to.
# member_name               - the name the member is to be refered to in the roster.
# individual_amount_pretax  - the amount of food/drink the member ordered.
#
# Returns: 
# the name of the member added.
#
# State Changes:
# Adds to the @members_attending hash *in the check object referenced.*

  def add_member_to_check(name_of_check,member_name,individual_amount_pretax)
    if name_of_check.settled == :no
      name_of_check.members_attending[member_name] = individual_amount_pretax
      name_of_check.number_of_guests += 1
    end
    return member_name
  end
  
# Public: #add_check_to_log
# Add the settlement of a check to the club log for future note.
#
# Parameters:
# check_object - the check object the method is pulling from.
# description  - a string or other value to remember this event by.
#
# Returns: 
# the log entry just added.
#
# State Changes:
# Adds to the @log hash.

  def add_check_to_log(check_object, description)
    if check_object.settled == :yes
      @log[description] = check_object.settle
      check_object.settle.each do |name, paid|
        puts check_object.settle[name]
        @roster[name] = 0 if @roster[name] == nil
        @roster[name] += paid.to_f
      end
    end
    return @log[description]
  end
  
end

superpals = DinnerClub.new
pizza = Check.new(36.50)
superpals.add_member_to_check(pizza,'Batman',12.12)
superpals.add_member_to_check(pizza,'Barbara',10.0)
superpals.add_member_to_check(pizza,'Dick',8.92)
pizza.split_individually
pizza.set_gratuity(26)
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
scotch.set_gratuity(-30)
scotch.settle
superpals.add_check_to_log(scotch,'Bought a round for the gang.')
puts superpals.log
binding.pry
    