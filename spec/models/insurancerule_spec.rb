# == Schema Information
#
# Table name: insurancerules
#
#  id               :integer         not null, primary key
#  country_id       :integer
#  salary_ceiling   :integer         default(1000000)
#  startend_prorate :boolean         default(TRUE)
#  startend_date    :integer         default(15)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Insurancerule do
  
  before(:each) do
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @attr =   { :salary_ceiling => 4000 } 
  end

  it "should have an insurance rule as soon as the country is created" do
    @country.insurancerule.should be_valid
  end

  it "should require a country_id" do
    no_country_rule = Insurancerule.new(@attr.merge(:country_id => nil))
    no_country_rule.should_not be_valid
  end
  
  it "should require a salary_ceiling" do
    no_ceiling_rule = Insurancerule.new(@attr.merge(:salary_ceiling => nil))
    no_ceiling_rule.should_not be_valid
  end
  
  it "should require a startend_date" do
    no_startend_rule = Insurancerule.new(@attr.merge(:startend_date => nil))
    no_startend_rule.should_not be_valid
  end
  
  it "should have a numeric startend_date" do
    string_startend_rule = Insurancerule.new(@attr.merge(:startend_date => "fifteen"))
    string_startend_rule.should_not be_valid
  end
  
  it "should have an integer as startend_date" do
    fraction_startend_rule = Insurancerule.new(@attr.merge(:startend_date => 15.25))
    fraction_startend_rule.should_not be_valid
  end
  
  it "should not have a startend_date > 28" do
    large_startend_rule = Insurancerule.new(@attr.merge(:startend_date => 29))
    large_startend_rule.should_not be_valid
  end
  
  it "should not have a startend_date < 1" do
    small_startend_rule = Insurancerule.new(@attr.merge(:startend_date => 0))
    small_startend_rule.should_not be_valid
  end
  
end
