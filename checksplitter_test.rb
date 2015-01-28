require_relative 'checksplitter'
require 'minitest/autorun'

class CheckSplitterTest < Minitest::Test
  
  def test_set_gratuity
    testcheck = Check.new(350.0)
    testcheck.set_gratuity(25)
    assert_equal 0.25, testcheck.gratuity
  end
  
  def test_set_grat_minimum
    testcheck = Check.new(600.00)
    testcheck.set_gratuity(5)
    assert_equal 0.1, testcheck.gratuity
  end
  
  #note that if you move #add_member_to_check into the check class these will break.
  def test_split_individually
    testcheck = Check.new(100.00)
    testclub = DinnerClub.new
    testclub.add_member_to_check(testcheck,"member1",10.0)
    testclub.add_member_to_check(testcheck,"member2",40.0)
    testclub.add_member_to_check(testcheck,"member3",50.0)
    testhash = testcheck.split_individually
    assert_equal testhash['member1'], 0.1
    assert_equal testhash['member2'], 0.4
    assert_equal testhash['member3'], 0.5
  end
  
  def test_split_evenly
    testcheck = Check.new(100.00)
    testclub = DinnerClub.new
    testclub.add_member_to_check(testcheck,"member1",10.0)
    testclub.add_member_to_check(testcheck,"member2",40.0)
    testclub.add_member_to_check(testcheck,"member3",50.0)
    testhash = testcheck.split_evenly
    assert_equal testhash['member1'], 0.33
    assert_equal testhash['member2'], 0.33
    assert_equal testhash['member3'], 0.33
  end
  
  def test_all_on
    testcheck = Check.new(100.00)
    testclub = DinnerClub.new
    testclub.add_member_to_check(testcheck,"member1",10.0)
    testclub.add_member_to_check(testcheck,"member2",40.0)
    testclub.add_member_to_check(testcheck,"member3",50.0)
    testhash = testcheck.all_on('member1')
    assert_equal testhash['member1'], 1
    assert_equal testhash['member2'], 0
    assert_equal testhash['member3'], 0
  end
end