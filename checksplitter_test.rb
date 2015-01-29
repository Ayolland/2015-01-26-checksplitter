require_relative 'checksplitter'
require 'minitest/autorun'

class CheckSplitterTest < Minitest::Test
  
  def test_set_gratuity
    testcheck = Check.new(350.0)
    testcheck.set_gratuity(25)
    assert_equal 0.25, testcheck.gratuity
  end
  
  def test_set_grat_minimum
    testcheck = Check.new(600.00, 7)
    assert_equal 0.1, testcheck.gratuity
    testcheck.set_gratuity(5)
    assert_equal 0.1, testcheck.gratuity
  end
  
  def test_split_individually
    testcheck = Check.new(100.00)
    testcheck.add_diners('member1', 'member2', 'member3')
    testcheck.diners_tab('member1',10.0)
    testcheck.diners_tab('member2',40.0)
    testcheck.diners_tab('member3',50.0)
    testhash = testcheck.split_individually
    assert_equal testhash['member1'], 0.1
    assert_equal testhash['member2'], 0.4
    assert_equal testhash['member3'], 0.5
    assert_equal :yes, testcheck.split
  end
  
  def test_split_evenly
    testcheck = Check.new(100.00)
    testcheck.add_diners('member1', 'member2', 'member3')
    testcheck.diners_tab('member1',10.0)
    testcheck.diners_tab('member2',40.0)
    testcheck.diners_tab('member3',50.0)
    testhash = testcheck.split_evenly
    assert_equal testhash['member1'].round(2), 0.33
    assert_equal testhash['member2'].round(2), 0.33
    assert_equal testhash['member3'].round(2), 0.33
    assert_equal :yes, testcheck.split
  end
  
  def test_all_on
    testcheck = Check.new(100.00)
    testcheck.add_diners('member1', 'member2', 'member3')
    testcheck.diners_tab('member1',10.0)
    testcheck.diners_tab('member2',40.0)
    testcheck.diners_tab('member3',50.0)
    testhash = testcheck.all_on('member3')
    assert_equal testhash['member1'], 0.0
    assert_equal testhash['member2'], 0.0
    assert_equal testhash['member3'], 1.0
    assert_equal :yes, testcheck.split
  end
  
  def test_add_check_to_log
    testcheck = Check.new(60.00)
    testcheck.add_diners('member1', 'member2', 'member3')
    testcheck.split_evenly
    testcheck.settle
    testclub = DinnerClub.new
    testclub.add_check_to_log(testcheck,"Description")
    assert_equal 24, testclub.roster['member1']
  end
    
  def test_merge_x_into_y
    testcheck = Check.new(60.00)
    testcheck.add_diners('member1', 'member2', 'member3')
    testcheck.split_evenly
    testcheck.settle
    testclub = DinnerClub.new
    testclub.add_check_to_log(testcheck,"Description")
    testclub.merge_x_into_y('member1','member2')
    assert_nil testclub.roster['member1']
  end
  
end
