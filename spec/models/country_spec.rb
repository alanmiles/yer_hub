# == Schema Information
#
# Table name: countries
#
#  id             :integer         not null, primary key
#  country        :string(255)
#  nationality_id :integer
#  currency_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Country do
  
  before(:each) do
  
    @currency = Factory(:currency)
    @nationality = Factory(:nationality)
    @attr =   { :country => "United Arab Emirates", 
    		:currency_id => @currency.id,
    		:nationality_id => @nationality.id }
  end

  it "should create a new instance given valid attributes" do
    Country.create!(@attr)
  end

  it "should require a country name" do
    no_name_country = Country.new(@attr.merge(:country => ""))
    no_name_country.should_not be_valid
  end
  
  it "should have a name of less than 51 characters" do
    @country_name = "a" * 51
    long_name_country = Country.new(@attr.merge(:country => @country_name))
    long_name_country.should_not be_valid
  end
  
  it "should require a nationality_id" do
    no_nationality_country = Country.new(@attr.merge(:nationality_id => nil))
    no_nationality_country.should_not be_valid
  end
  
  it "should require a currency_id" do
    no_currency_country = Country.new(@attr.merge(:currency_id => nil))
    no_currency_country.should_not be_valid
  end
 
  describe "duplication rules" do
  
    before(:each) do
      @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
      @nationality2 = Factory(:nationality, :nationality => "British")
    end
     
    it "should not accept a duplicate_name" do
      Country.create!(@attr)
      duplicate_name_country = Country.new(@attr.merge(:country => "United Arab Emirates", :currency_id => @currency2.id,
      							:nationality_id => @nationality2.id))
      duplicate_name_country.should_not be_valid
    end
    
    it "should not accept a duplicate_name where only the case is diffferent" do
      Country.create!(@attr)
      duplicate_name_country = Country.new(@attr.merge(:country => "united arab emirates", :currency_id => @currency2.id,
      							:nationality_id => @nationality2.id))
      duplicate_name_country.should_not be_valid
    end
    
    
    it "should accept a duplicate nationality_id" do
      Country.create!(@attr)
      duplicate_nationality_country = Country.new(@attr.merge(:country => "Dubai", :currency_id => @currency2.id))
      duplicate_nationality_country.should be_valid
    end
    
    it "should accept a duplicate currency_id" do
      Country.create!(@attr)
      duplicate_currency_country = Country.new(@attr.merge(:country => "Dubai", :nationality_id => @nationality2.id))
      duplicate_currency_country.should be_valid
    end
  end
end
