# == Schema Information
#
# Table name: sicknessallowances
#
#  id             :integer         not null, primary key
#  country_id     :integer
#  sick_days_from :integer
#  sick_days_to   :integer
#  deduction_rate :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Sicknessallowance do
  
  before(:each) do
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @attr =   { :country_id => @country.id, :sick_days_from => 0, :sick_days_to => 15,
    		:deduction_rate => 0 } 
  end
  
  it "should create a new instance given valid attributes" do
    Sicknessallowance.create!(@attr)
  end
  
  it "should have a country_id" do
    no_country_named = Sicknessallowance.new(@attr.merge(:country_id => nil))
    no_country_named.should_not be_valid
  end
  
  it "should have a 'sick_days_from' value" do
    missing_range_bottom = Sicknessallowance.new(@attr.merge(:sick_days_from => nil))
    missing_range_bottom.should_not be_valid
  end
  
  it "should have an integer 'sick_days_from' value" do
    fraction_range_bottom = Sicknessallowance.new(@attr.merge(:sick_days_from => 0.5))
    fraction_range_bottom.should_not be_valid
  end
  
  it "should accept a 0 'sick_days_from' value" do
    zero_range_bottom = Sicknessallowance.new(@attr.merge(:sick_days_from => 0))
    zero_range_bottom.should be_valid
  end
  
  it "should not accept a negative 'sick_days_from' value" do
    negative_range_bottom = Sicknessallowance.new(@attr.merge(:sick_days_from => -1))
    negative_range_bottom.should_not be_valid
  end
  
  it "should not accept a 'sick_days_from' value > 365" do
    high_range_bottom = Sicknessallowance.new(@attr.merge(:sick_days_from => 366))
    high_range_bottom.should_not be_valid
  end
  
  it "should have a 'sick_days_to' value" do
    missing_range_top = Sicknessallowance.new(@attr.merge(:sick_days_to => nil))
    missing_range_top.should_not be_valid
  end
  
  it "should have an integer 'sick_days_to' value" do
    fraction_range_top = Sicknessallowance.new(@attr.merge(:sick_days_to => 15.5))
    fraction_range_top.should_not be_valid
  end
  
  it "should not accept a 'sick_days_to' value of 1" do
    low_range_top = Sicknessallowance.new(@attr.merge(:sick_days_to => 0))
    low_range_top.should_not be_valid
  end
  
  it "should not accept a 'sick_days_to' value of 366 or above" do
    high_range_top = Sicknessallowance.new(@attr.merge(:sick_days_to => 366))
    high_range_top.should_not be_valid
  end
  
  it "should have a 'deduction_rate' value" do
    no_deduction_rate = Sicknessallowance.new(@attr.merge(:deduction_rate => nil))
    no_deduction_rate.should_not be_valid
  end
  
  it "should have an integer 'deduction_rate" do
    fraction_deduction_rate = Sicknessallowance.new(@attr.merge(:deduction_rate => 50.5))
    fraction_deduction_rate.should_not be_valid
  end
  
  it "should not have a deduction_rate > 100" do
    high_deduction_rate = Sicknessallowance.new(@attr.merge(:deduction_rate => 101))
    high_deduction_rate.should_not be_valid
  end
  
  it "should not have a negative deduction rate" do
    low_deduction_rate = Sicknessallowance.new(@attr.merge(:deduction_rate => -1))
    low_deduction_rate.should_not be_valid
  end
  
  it "should prevent sickness allowance overlap"
  
  it "should prevent duplicate 'sick days_from' for the same country" do
    Sicknessallowance.create!(@attr)
    @duplicate_low_days = Sicknessallowance.new(@attr.merge(:sick_days_from => 0, :sick_days_to => 30))
    @duplicate_low_days.should_not be_valid
  end
  
  it "should prevent duplicate 'sick_days_to' for the same country" do
    Sicknessallowance.create!(@attr)
    @duplicate_high_days = Sicknessallowance.new(@attr.merge(:sick_days_from => 3, :sick_days_to => 15))
    @duplicate_high_days.should_not be_valid
  end
  
  it "should allow duplicate high and low bands for a different country" do
    @nationality2 = Factory(:nationality, :nationality => "Welsh")
    @currency2 = Factory(:currency, :currency => "Ingots", :abbreviation => "ING")
    @country2 = Factory(:country, :country => "Wales", :nationality_id => @nationality2.id, :currency_id => @currency2.id)
    @attr2 =   { :country_id => @country2.id, :sick_days_from => 0, :sick_days_to => 15,
    		:deduction_rate => 0 } 
  
    Sicknessallowance.create!(@attr)
    duplicate_different_country = Sicknessallowance.new(@attr2)
    duplicate_different_country.should be_valid
  end
end
