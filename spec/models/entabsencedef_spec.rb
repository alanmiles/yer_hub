# == Schema Information
#
# Table name: entabsencedefs
#
#  id               :integer         not null, primary key
#  enterprise_id    :integer
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

describe Entabsencedef do
  
  before(:each) do
  
    @abscat = Factory(:abscat, :approved => true)
    @sector = Factory(:sector)
    @currency = Factory(:currency)
    @nationality = Factory(:nationality)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @enterprise = Factory(:enterprise, :country_id => @country.id, :sector_id => @sector.id)
    @enterprise2 = Factory(:enterprise, :name => "Enterprise 2", :short_name => "Ent2", 
    			   :country_id => @country.id, :sector_id => @sector.id)
  
    @attr = { :enterprise_id => @enterprise.id, :category => "Sickness on full pay", :abbreviation => "SF", :max_per_year => 15,
    		:sickness => true }
  end
  
  it "should already have an EntAbsenceDef table" do
    Entabsencedef.where("enterprise_id = ?", @enterprise).count.should_not == 0
  end
  
  it "should create a new instance given valid attributes" do
    Entabsencedef.create!(@attr)
  end
  
  it "should have an enterprise_id" do
    @missing_enterprise = Entabsencedef.new(@attr.merge(:enterprise_id => nil))
    @missing_enterprise.should_not be_valid
  end
  
  it "should have a category" do
    @missing_category = Entabsencedef.new(@attr.merge(:category => ""))
    @missing_category.should_not be_valid
  end
  
  it "should not have a duplicate category in the same enterprise" do
    Entabsencedef.create(@attr)
    @duplicate = Entabsencedef.new(@attr, :abbreviation => "D1")
    @duplicate.should_not be_valid
  end
  
  it "should permit a duplicate category in a different enterprise" do
    Entabsencedef.create(@attr)
    @non_duplicate = Entabsencedef.new(@attr.merge(:abbreviation => "D1", :enterprise_id => @enterprise2.id))
    @non_duplicate.should be_valid
  end
  
  it "should not have a long category" do
    @cat = "a" * 51
    @long_category = Entabsencedef.new(@attr.merge(:category => @cat))
    @long_category.should_not be_valid
  end
  
  it "should have an abbreviation" do
    @missing_abbreviation = Entabsencedef.new(@attr.merge(:abbreviation => ""))
    @missing_abbreviation.should_not be_valid
  end
  
  it "should not have a duplicate abbreviation in the same enterprise" do
    Entabsencedef.create(@attr)
    @duplicate_abbrev = Entabsencedef.new(@attr.merge(:category => "Business trip"))
    @duplicate_abbrev.should_not be_valid
  end
  
  it "should permit a duplicate category in a different enterprise" do
    Entabsencedef.create(@attr)
    @non_duplicate_abbrev = Entabsencedef.new(@attr.merge(:enterprise_id => @enterprise2.id, :category => "Business trip"))
    @non_duplicate_abbrev.should be_valid
  end
  
  
  it "should not have a long abbreviation" do
    @abbrev = "a" * 3
    @long_abbreviation = Entabsencedef.new(@attr.merge(:abbreviation => @abbrev))
    @long_abbreviation.should_not be_valid
  end
   
  it "should allow a blank 'max_per_year'" do
    @blank_max = Entabsencedef.new(@attr.merge(:max_per_year => nil))
    @blank_max.should be_valid
  end
  
  it "should not have a fraction in 'max_per_year'" do
    @fraction_max = Entabsencedef.new(@attr.merge(:max_per_year => 15.3))
    @fraction_max.should_not be_valid
  end
  
  it "should have a salary deduction" do
    @no_deduction = Entabsencedef.new(@attr.merge(:salary_deduction => nil))
    @no_deduction.should_not be_valid
  end
  
  it "should not have a salary deduction > 100" do
    @large_deduction = Entabsencedef.new(@attr.merge(:salary_deduction => 101))
    @large_deduction.should_not be_valid
  end
end
