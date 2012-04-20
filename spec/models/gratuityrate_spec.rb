# == Schema Information
#
# Table name: gratuityrates
#
#  id                   :integer         not null, primary key
#  country_id           :integer
#  service_years_from   :integer
#  service_years_to     :integer
#  resignation_rate     :decimal(5, 2)
#  non_resignation_rate :decimal(5, 2)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe Gratuityrate do
  
  before(:each) do
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @attr =   { :country_id => @country.id, :service_years_from => 0, :service_years_to => 3,
    		:resignation_rate => 0, :non_resignation_rate => 50 } 
  end
  
  it "should create a new instance given valid attributes" do
    Gratuityrate.create!(@attr)
  end
  
  it "should have a country_id" do
    no_country_rate = Gratuityrate.new(@attr.merge(:country_id => nil))
    no_country_rate.should_not be_valid
  end
  
  it "should have a 'service from' value" do
    no_service_from = Gratuityrate.new(@attr.merge(:service_years_from => nil))
    no_service_from.should_not be_valid
  end
  
  it "should set an integer for 'service_from" do
    no_service_from = Gratuityrate.new(@attr.merge(:service_years_from => 0.5))
    no_service_from.should_not be_valid
  end
  
  it "should have a 'service to' value" do
    no_service_to = Gratuityrate.new(@attr.merge(:service_years_to => nil))
    no_service_to.should_not be_valid
  end
  
  it "should set an integer for 'service_to" do
    no_service_from = Gratuityrate.new(@attr.merge(:service_years_to => 3.5))
    no_service_from.should_not be_valid
  end

  it "should have a resignation rate" do
    no_resignation = Gratuityrate.new(@attr.merge(:resignation_rate => nil))
    no_resignation.should_not be_valid
  end
  
  it "should set a number for 'resignation_rate'" do
    text_resignation = Gratuityrate.new(@attr.merge(:resignation_rate => "three"))
    text_resignation.should_not be_valid
  end 
  
  it "should have a non-resignation rate" do
    no_non_resignation = Gratuityrate.new(@attr.merge(:non_resignation_rate => nil))
    no_non_resignation.should_not be_valid
  end 
  
  it "should set a number for 'non_resignation_rate'" do
    text_non_resignation = Gratuityrate.new(@attr.merge(:non_resignation_rate => "four"))
    text_non_resignation.should_not be_valid
  end 
  
  describe "duplicates" do
  
    it "should not have a duplicate 'service_from' value for the same country" do
      Gratuityrate.create!(@attr)
      @duplicate_service_years_from = Gratuityrate.new(@attr.merge(:service_years_from => 0, :service_years_to => 4))
      @duplicate_service_years_from.should_not be_valid
    end
    
    it "should not have a duplicate 'service_to' value for the same country" do
      Gratuityrate.create!(@attr)
      @duplicate_service_years_to = Gratuityrate.new(@attr.merge(:service_years_from => 1, :service_years_to => 3))
      @duplicate_service_years_to.should_not be_valid
    end  
    
    before(:each) do
      @nationality2 = Factory(:nationality, :nationality => "British")
      @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
      @country2 = Factory(:country, :country => "United Kingdom", :currency_id => @currency2.id, :nationality_id => @nationality2.id) 
    end
    
    it "should allow duplicate service year values if not in the same country" do
      Gratuityrate.create!(@attr)
      @no_duplicate_service_years = Gratuityrate.new(@attr.merge(:country_id => @country2, :service_years_from => 0, :service_years_to => 3))
      @no_duplicate_service_years.should be_valid
    
    end
  end
  
end
