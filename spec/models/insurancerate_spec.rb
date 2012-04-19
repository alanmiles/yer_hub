# == Schema Information
#
# Table name: insurancerates
#
#  id              :integer         not null, primary key
#  country_id      :integer
#  low_salary      :integer
#  high_salary     :integer
#  employer_nats   :decimal(4, 2)
#  employer_expats :decimal(4, 2)
#  employee_nats   :decimal(4, 2)
#  employee_expats :decimal(4, 2)
#  position        :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Insurancerate do
  
  before(:each) do
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @attr =   { :country_id => @country.id, :low_salary => 0, :high_salary => 2000,
    		:employer_nats => 10, :employer_expats => 3, :employee_nats => 6,
    		:employee_expats => 0  } 
  end
  
  it "should create a new instance given valid attributes" do
    Insurancerate.create!(@attr)
  end
  
  it "should have a country_id" do
    no_country_rate = Insurancerate.new(@attr.merge(:country_id => nil))
    no_country_rate.should_not be_valid
  end
  
  it "should have a low salary" do
    no_low_salary = Insurancerate.new(@attr.merge(:low_salary => nil))
    no_low_salary.should_not be_valid
  end
  
  it "should have an integer low salary value" do
    fraction_low_salary = Insurancerate.new(@attr.merge(:low_salary => 0.5))
    fraction_low_salary.should_not be_valid
  end
  
  it "should have a high salary" do
    no_high_salary = Insurancerate.new(@attr.merge(:high_salary => nil))
    no_high_salary.should_not be_valid
  end
  
  it "should have an integer high salary value" do
    fraction_high_salary = Insurancerate.new(@attr.merge(:high_salary => 2000.975))
    fraction_high_salary.should_not be_valid
  end
  
  it "should have an employer_nats value" do
    no_employer_nats = Insurancerate.new(@attr.merge(:employer_nats => nil))
    no_employer_nats.should_not be_valid
  end
  
  it "should have not have an employer_nats value > 100" do
    high_employer_nats = Insurancerate.new(@attr.merge(:employer_nats => 101))
    high_employer_nats.should_not be_valid
  end
  
  it "should have an employer_expats value" do
    no_employer_expats = Insurancerate.new(@attr.merge(:employer_expats => nil))
    no_employer_expats.should_not be_valid
  end
  
  it "should not have employer_expats value > 100" do
    high_employer_expats = Insurancerate.new(@attr.merge(:employer_expats => 101))
    high_employer_expats.should_not be_valid
  end
  
  it "should have an employee_nats value" do
    no_employee_nats = Insurancerate.new(@attr.merge(:employee_nats => nil))
    no_employee_nats.should_not be_valid
  end
  
  it "should not have an employee_nats value > 100" do
    high_employee_nats = Insurancerate.new(@attr.merge(:employee_nats => 101))
    high_employee_nats.should_not be_valid
  end
 
  it "should have an employee_expats value" do
    no_employee_expats = Insurancerate.new(@attr.merge(:employee_expats => nil))
    no_employee_expats.should_not be_valid
  end
  
  it "should not have an employee_expats value > 100" do
    high_employee_expats = Insurancerate.new(@attr.merge(:employee_expats => 101))
    high_employee_expats.should_not be_valid
  end
  
  it "should have a position auto-set" do
    @insurancerate = Insurancerate.create!(@attr)
    @insurancerate.position.should == 1
  end
  
  it "should prevent salary range overlap"
  
  it "should prevent duplicate low salaries for the same country" do
    Insurancerate.create!(@attr)
    @duplicate_low_salary = Insurancerate.new(@attr.merge(:low_salary => 0, :high_salary => 4000))
    @duplicate_low_salary.should_not be_valid
  end
  
  it "should prevent duplicate high salaries for the same country" do
    Insurancerate.create!(@attr)
    @duplicate_high_salary = Insurancerate.new(@attr.merge(:low_salary => 200, :high_salary => 2000))
    @duplicate_high_salary.should_not be_valid
  end
  
  it "should allow duplicate high and low salaries for a different country" do
    @nationality2 = Factory(:nationality, :nationality => "Welsh")
    @currency2 = Factory(:currency, :currency => "Ingots", :abbreviation => "ING")
    @country2 = Factory(:country, :country => "Wales", :nationality_id => @nationality2.id, :currency_id => @currency2.id)
    @attr2 =   { :country_id => @country2.id, :low_salary => 0, :high_salary => 2000,
    		:employer_nats => 10, :employer_expats => 3, :employee_nats => 6,
    		:employee_expats => 0  } 
  
    Insurancerate.create!(@attr)
    duplicate_different_country = Insurancerate.new(@attr2)
    duplicate_different_country.should be_valid
  end
end
