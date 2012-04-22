# == Schema Information
#
# Table name: legislations
#
#  id                   :integer         not null, primary key
#  country_id           :integer
#  retirement_men       :integer         default(65)
#  retirement_women     :integer         default(60)
#  sickness_accruals    :boolean         default(FALSE)
#  max_sickness_accrual :integer         default(0)
#  probation_days       :integer         default(90)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe Legislation do
  
  before(:each) do
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @attr =   { :sickness_accruals => true, :max_sickness_accrual => 182 } 
  end

  it "should have an insurance rule as soon as the country is created" do
    @country.legislation.should be_valid
  end

  it "should require a country_id" do
    no_country_rule = Legislation.new(@attr.merge(:country_id => nil))
    no_country_rule.should_not be_valid
  end
  
  it "should require a requirement age for men" do
    no_retirement_men = Legislation.new(@attr.merge(:retirement_men => nil))
    no_retirement_men.should_not be_valid
  end
  
  it "should require a requirement age for women" do
    no_retirement_women = Legislation.new(@attr.merge(:retirement_women => nil))
    no_retirement_women.should_not be_valid
  end
  
  it "should have a maximum sickness accrual" do
    no_maximum_sickness = Legislation.new(@attr.merge(:max_sickness_accrual => nil))
    no_maximum_sickness.should_not be_valid
  end
  
  it "should have a probation_days value" do
    no_probation_days = Legislation.new(@attr.merge(:probation_days => nil))
    no_probation_days.should_not be_valid
  end
  
end
