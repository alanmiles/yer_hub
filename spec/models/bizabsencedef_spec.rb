# == Schema Information
#
# Table name: bizabsencedefs
#
#  id               :integer         not null, primary key
#  business_id      :integer
#  category         :string(255)
#  abbreviation     :string(255)
#  description      :string(255)
#  max_per_year     :integer
#  salary_deduction :integer         default(0)
#  sickness         :boolean         default(FALSE)
#  push             :boolean         default(FALSE)
#  inactive         :boolean         default(FALSE)
#  updated_by       :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Bizabsencedef do
  
  before(:each) do
  
    @abscat = Factory(:abscat, :approved => true)
    @sector = Factory(:sector)
    @currency = Factory(:currency)
    @nationality = Factory(:nationality)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @enterprise = Factory(:enterprise, :country_id => @country.id, :sector_id => @sector.id)
    @enterprise2 = Factory(:enterprise, :name => "Enterprise 2", :short_name => "Ent2", 
    			   :country_id => @country.id, :sector_id => @sector.id)
    @business = Business.where("enterprise_id = ?", @enterprise).first
    @business2 = Business.where("enterprise_id = ?", @enterprise2).first
    
    @attr = { :business_id => @business.id, :category => "Sickness on full pay", :abbreviation => "SF", :max_per_year => 15,
    		:sickness => true }
  end
  
  it "should already have a BizAbsenceDef table" do
    Bizabsencedef.where("business_id = ?", @business).count.should_not == 0
  end
  
  it "should create a new instance given valid attributes" do
    Bizabsencedef.create!(@attr)
  end
  
  it "should have a business_id" do
    @missing_business = Bizabsencedef.new(@attr.merge(:business_id => nil))
    @missing_business.should_not be_valid
  end
  
  it "should have a category" do
    @missing_category = Bizabsencedef.new(@attr.merge(:category => ""))
    @missing_category.should_not be_valid
  end
  
  it "should not have a duplicate category in the same business" do
    Bizabsencedef.create(@attr)
    @duplicate = Bizabsencedef.new(@attr, :abbreviation => "D1")
    @duplicate.should_not be_valid
  end
  
  it "should permit a duplicate category in a different business" do
    Bizabsencedef.create(@attr)
    @non_duplicate = Bizabsencedef.new(@attr.merge(:abbreviation => "D1", :business_id => @business2.id))
    @non_duplicate.should be_valid
  end
  
  it "should not have a long category" do
    @cat = "a" * 51
    @long_category = Bizabsencedef.new(@attr.merge(:category => @cat))
    @long_category.should_not be_valid
  end
  
  it "should have an abbreviation" do
    @missing_abbreviation = Bizabsencedef.new(@attr.merge(:abbreviation => ""))
    @missing_abbreviation.should_not be_valid
  end
  
  it "should not have a duplicate abbreviation in the same business" do
    Bizabsencedef.create(@attr)
    @duplicate_abbrev = Bizabsencedef.new(@attr.merge(:category => "Business trip"))
    @duplicate_abbrev.should_not be_valid
  end
  
  it "should permit a duplicate category in a different business" do
    Bizabsencedef.create(@attr)
    @non_duplicate_abbrev = Bizabsencedef.new(@attr.merge(:business_id => @business2.id, :category => "Business trip"))
    @non_duplicate_abbrev.should be_valid
  end
  
  
  it "should not have a long abbreviation" do
    @abbrev = "a" * 3
    @long_abbreviation = Bizabsencedef.new(@attr.merge(:abbreviation => @abbrev))
    @long_abbreviation.should_not be_valid
  end
   
  it "should allow a blank 'max_per_year'" do
    @blank_max = Bizabsencedef.new(@attr.merge(:max_per_year => nil))
    @blank_max.should be_valid
  end
  
  it "should not have a fraction in 'max_per_year'" do
    @fraction_max = Bizabsencedef.new(@attr.merge(:max_per_year => 15.3))
    @fraction_max.should_not be_valid
  end
  
  it "should have a salary deduction" do
    @no_deduction = Bizabsencedef.new(@attr.merge(:salary_deduction => nil))
    @no_deduction.should_not be_valid
  end
  
  it "should not have a salary deduction > 100" do
    @large_deduction = Bizabsencedef.new(@attr.merge(:salary_deduction => 101))
    @large_deduction.should_not be_valid
  end
end
