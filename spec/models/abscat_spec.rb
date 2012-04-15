# == Schema Information
#
# Table name: abscats
#
#  id           :integer         not null, primary key
#  category     :string(255)
#  abbreviation :string(255)
#  approved     :boolean         default(FALSE)
#  created_by   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Abscat do
  
  before(:each) do
    @user = Factory(:user)
    @attr =   { :category => "Unpaid leave", 
    		:abbreviation => "UL",
      		:created_by => @user.id }
  end

  it "should create a new instance given valid attributes" do
    Abscat.create!(@attr)
  end

  it "should require a category" do
    no_cat_absence = Abscat.new(@attr.merge(:category => "", :abbreviation => "UA", :created_by => @user.id))
    no_cat_absence.should_not be_valid
  end
  
  it "should have a category of less than 51 characters" do
    @category_name = "a" * 51
    long_name_category = Abscat.new(@attr.merge(:category => @category_name))
    long_name_category.should_not be_valid
  end
  
  it "should require an abbreviation" do
    no_abbreviation_category = Abscat.new(@attr.merge(:category => "Sickness on full pay", :abbreviation => ""))
    no_abbreviation_category.should_not be_valid
  end
  
  it "should have an abbreviation of less than 3 characters" do
    @abbreviation = "a" * 3
    long_abbreviation_category = Abscat.new(@attr.merge(:abbreviation => @abbreviation))
    long_abbreviation_category.should_not be_valid
  end
  
  it "should have an abbreviation of more than 1 character" do
    @abbreviation = "a"
    short_abbreviation_category = Abscat.new(@attr.merge(:abbreviation => @abbreviation))
    short_abbreviation_category.should_not be_valid
  end
  
  it "should require a creator" do
    no_creator_category = Abscat.new(@attr.merge(:category => "Compensatory leave", :abbreviation => "CL", :created_by => nil))
    no_creator_category.should_not be_valid
  end
  
  
  describe "duplication" do
  
    before(:each) do
      Abscat.create!(@attr)
    end
  
    it "should not have a duplicate category" do
      duplicate_category = Abscat.new(@attr.merge(:category => "Unpaid leave", :abbreviation => "AB"))
      duplicate_category.should_not be_valid
    end
  
    it "should not have a duplicate category up to case" do
      duplicate_case_category = Abscat.new(@attr.merge(:category => "unpaid leave", :abbreviation => "AB"))
      duplicate_case_category.should_not be_valid
    end
  
    it "should not have a duplicate abbreviation" do
      duplicate_abbreviation_category = Abscat.new(@attr.merge(:category => "Sickness Full Pay", :abbreviation => "UL"))
      duplicate_abbreviation_category.should_not be_valid
    end
  
    it "should not have a duplicate abbreviation up to case" do
      case_abbreviation_category = Abscat.new(@attr.merge(:category => "Sickness Full Pay", :abbreviation => "ul"))
      case_abbreviation_category.should_not be_valid
    end
  end
end
