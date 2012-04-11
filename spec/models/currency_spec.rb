# == Schema Information
#
# Table name: currencies
#
#  id                :integer         not null, primary key
#  currency          :string(255)
#  abbreviation      :string(255)
#  dec_places        :integer
#  change_to_dollars :decimal(8, 5)
#  approved          :boolean         default(FALSE)
#  created_by        :integer
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Currency do
 
  before(:each) do
    @user = Factory(:user)
    @attr =   { :currency => "Pound Sterling", 
    		:abbreviation => "GBP",
    		:dec_places => 2,
      		:created_by => @user.id }
  end

  it "should create a new instance given valid attributes" do
    Currency.create!(@attr)
  end

  it "should require a currency" do
    no_name_currency = Currency.new(@attr.merge(:currency => "", :abbreviation => "USD"))
    no_name_currency.should_not be_valid
  end
  
  it "should have a currency of less than 51 characters" do
    @currency_name = "a" * 51
    long_name_currency = Currency.new(@attr.merge(:currency => @currency_name))
    long_name_currency.should_not be_valid
  end
  
  it "should require an abbreviation" do
    no_abbreviation_currency = Currency.new(@attr.merge(:currency => "US Dollar", :abbreviation => ""))
    no_abbreviation_currency.should_not be_valid
  end
  
  it "should have an abbreviation of less than 4 characters" do
    @abbreviation = "a" * 4
    long_abbreviation_currency = Currency.new(@attr.merge(:abbreviation => @abbreviation))
    long_abbreviation_currency.should_not be_valid
  end
  
  it "should declare decimal places" do
    no_decpl_currency = Currency.new(@attr.merge(:currency => "US Dollar", :abbreviation => "USD", :dec_places => nil))
    no_decpl_currency.should_not be_valid
  end
  
  it "should require a creator" do
    no_creator_currency = Currency.new(@attr.merge(:currency => "US Dollar", :abbreviation => "USD", :dec_places => 2, :created_by => nil))
    no_creator_currency.should_not be_valid
  end
  
  it "should have a numeric currency rate" do
    no_rate_currency = Currency.new(@attr.merge(:currency => "US Dollar", :abbreviation => "USD", :dec_places => 2, 
    						:created_by => @user.id, :change_to_dollars => "two"))
    no_rate_currency.should_not be_valid
  end
  
  it "should have a numeric value for dec_places" do
    wrong_decimal_currency = Currency.new(@attr.merge(:currency => "US Dollar", :abbreviation => "USD", :dec_places => 2, 
    						:created_by => @user.id, :change_to_dollars => 1.53, :dec_places => "Two"))
    wrong_decimal_currency.should_not be_valid
  end
  
  it "should have an integer dec_places declaration" do
    fraction_decimal_currency = Currency.new(@attr.merge(:currency => "US Dollar", :abbreviation => "USD", :dec_places => 2, 
    						:created_by => @user.id, :change_to_dollars => 1.53, :dec_places => 2.11))
    fraction_decimal_currency.should_not be_valid
  end
  
  describe "duplication" do
  
    before(:each) do
      Currency.create!(@attr)
    end
  
    it "should not have a duplicate currency" do
      duplicate_currency = Currency.new(@attr.merge(:currency => "Pound Sterling", :abbreviation => "USD"))
      duplicate_currency.should_not be_valid
    end
  
    it "should not have a duplicate currency up to case" do
      duplicate_case_currency = Currency.new(@attr.merge(:currency => "pound sterling", :abbreviation => "USD"))
      duplicate_case_currency.should_not be_valid
    end
  
    it "should not have a duplicate abbreviation" do
      duplicate_abbreviation_currency = Currency.new(@attr.merge(:currency => "US Dollar", :abbreviation => "GBP"))
      duplicate_abbreviation_currency.should_not be_valid
    end
  
    it "should not have a duplicate abbreviation up to case" do
      case_abbreviation_currency = Currency.new(@attr.merge(:currency => "US Dollar", :abbreviation => "gbp"))
      case_abbreviation_currency.should_not be_valid
    end
  end
end
