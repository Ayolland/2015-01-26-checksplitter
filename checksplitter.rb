require 'pry'

# Class: Check (previously checksplitter.)
#
# This class represents a check that needs to be split by one of three methods by the members of a DinnerCLub.
#
# Attributes:
# @total_after_tax   - The total value of the check when presented.
# @members_tabs      - A hash filled by the DiningClub class, keys are member names, 
#                      values are the amount each member ordered for this check.
# @members_share     - A hash, keys are names, values are the percentage of the 
#                      total bill the member will end up paying.
# @split             - This marks if the check has been split up yet.
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
# #add_diners
# #diners_tab

class Check
  
  attr_reader :total_after_tax, :members_tabs, :members_share, :gratuity, :settled, :split
  attr_accessor :number_of_guests
  
  def initialize(total_after_tax_temp, grat=20)
    @total_after_tax = total_after_tax_temp
    @members_tabs = {} 
    @members_share = {}
    @split = :no 
    @settled = :no 
    @number_of_guests = 0 
    @gratuity = grat * 0.01 
    @gratuity = 0.1 if @gratuity < 0.1
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
# fills @members_share with member names and shares using @members_tabs.
  
  def split_individually
    total_pre_tax = 0.0
    @members_tabs.each do |member_name, each_pre_tax|
     total_pre_tax += each_pre_tax
    end
    if total_pre_tax > 0.0
        @members_tabs.each do |member_name, each_pre_tax|
          @members_share[member_name] = (each_pre_tax / total_pre_tax).round(2)
        end
        @split = :yes
    end
    return @members_share
  end
  
# Public: #split_individually
# Assigns shares evenly, regardless of what each person ordered.
#
# Returns: 
# @members_share
#
# State Changes:
# fills @members_share with member names and shares using @members_tabs.
  
  def split_evenly
    @members_tabs.each do|member_name, each_pre_tax|
      @members_share[member_name] = (1.0 / @number_of_guests)
    end
    @split = :yes
    return @members_share
  end
  
# Public: #all_on()
# Sets one member's shares to 100% and all others to 0%
#
# Returns: 
# @members_share
#
# State Changes:
# fills @members_share with member names and shares using @members_tabs.
  
  def all_on(very_nice_person)
    @members_tabs.each do |member_name, each_pre_tax|
      if member_name == very_nice_person
        @members_share[member_name] = 1
      else
        @members_share[member_name] = 0
      end
    end
    @split = :yes
    return @members_share
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
    if @split == :yes
      settlement = {}
      @members_share.each do |name, share|
        settlement[name] = (calc_total * share).round(2)
      end
      @settled = :yes
      return settlement
    end
  end
  
# Public: #add_diners
# Adds any number of diners to a check, each with a tab of 0.
#
# Parameters:
# *diners  - a series of diners' names, ideally in strings
#
# Returns: 
# the array of diners
#
# State Changes:
# Adds to the @members_tabs hash.

    def add_diners(*diners_array)
      if @settled == :no
        diners_array.each do |diner_name|
          @members_tabs[diner_name] = 0
          @number_of_guests += 1
        end
      end
      return *diners_array
    end
    
# Public: #diners_tab
# Allows the setting of the amount each diner ordered.
# If the diner is not on the check, it should add them.
#
# Parameters:
# diner_name  - a diner's names, a key
#
# Returns: 
# the value of the @diners_tab hash using the name entered as a key.
#
# State Changes:
# edits to the @members_tabs hash.    
    
    def diners_tab(diner_name,pre_tax)
      @members_tabs[diner_name] = pre_tax
      return @members_tabs[diner_name]
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
# #add_check_to_log
# #member_total
# #merge_x_into_y


class DinnerClub
  
   attr_reader :roster, :log
  
  def initialize
    @roster = {}
    @log ={}
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
  
# Public: #member_total
# returns the total that member has spent as of yet.
#
# Returns: 
# the value in the @log hash corresponding for the name.
  
  def member_total(member_name)
    @roster[member_name]
  end
  
# Public: #merge_x_into_y
# Merge member's total in case of data-entry error.
#
# Parameters:
# fake_member   - the key in @roster for the member to be deleted.
# actual_member - the key in @roster for the member acount being merged into.
#
# Returns: 
# the new, merged total.
#
# State Changes:
# changes @roster, deletes an entry.
  
  def merge_x_into_y(fake_member,actual_member)
    @roster[actual_member] = ( member_total(actual_member) + member_total(fake_member) )
    @roster.delete(fake_member)
    return member_total(actual_member)
  end
  
end

# superpals = DinnerClub.new
# pizza = Check.new(36.50, 26)
# pizza.add_diners('Batman','Barbara','Dick')
# pizza.diners_tab('Batman',12.12)
# pizza.diners_tab('Barbara',10.0)
# pizza.diners_tab('Dick',8.92)
# pizza.split_individually
# pizza.settle
# superpals.add_check_to_log(pizza,'01-30 Went to fancy pizza with kids.')
# ice_cream = Check.new(22.07)
# ice_cream.add_diners('Dick', 'Clark', 'Barbara', 'Batman')
# ice_cream.split_evenly
# ice_cream.settle
# superpals.member_total('Dick')
# superpals.add_check_to_log(ice_cream,'01-30 Got ice cream with Clark after.')
# scotch = Check.new(150.00, 18)
# scotch.add_diners('Diana', 'Clark')
# scotch.diners_tab('Clark', 50.0)
# scotch.diners_tab('Diana', 50.0)
# scotch.diners_tab('Batman', 50.0)
# scotch.all_on('Batman')
# scotch.set_gratuity(-30)
# scotch.settle
# superpals.add_check_to_log(scotch,'Ran into the gang, bought a round')
# brunch = Check.new(46.77)
# brunch.add_diners('Batman', 'Batgirl')
# brunch.split_evenly
# brunch.settle
# superpals.add_check_to_log(brunch, 'Batgirl (?) invited me to brunch?')
# superpals.merge_x_into_y('Batgirl','Barbara')
# puts superpals.log
# binding.pry

  