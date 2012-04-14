# == Schema Information
#
# Table name: occupations
#
#  id         :integer         not null, primary key
#  occupation :string(255)
#  approved   :boolean         default(FALSE)
#  created_by :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Occupation do
  
  before(:each) do
    @user = Factory(:user)
    @attr =   { :occupation => "Accountant", 
      		:created_by => @user.id }
  end

  it "should create a new instance given valid attributes" do
    Occupation.create!(@attr)
  end

  it "should require an occupation name" do
    no_name_occupation = Occupation.new(@attr.merge(:occupation => "", :created_by => @user.id))
    no_name_occupation.should_not be_valid
  end
  
  it "should have an occupation of less than 51 characters" do
    @occupation_name = "a" * 51
    long_name_occupation = Occupation.new(@attr.merge(:occupation => @occupation_name, :created_by => @user.id))
    long_name_occupation.should_not be_valid
  end
  
  it "should require a creator" do
    no_creator_occupation = Occupation.new(@attr.merge(:occupation => "Manager", :created_by => nil))
    no_creator_occupation.should_not be_valid
  end
  
  describe "duplication" do
  
    before(:each) do
      Occupation.create!(@attr)
    end
  
    it "should not have a duplicate occupation" do
      duplicate_occupation = Occupation.new(@attr.merge(:occupation => "Accountant", :created_by => @user.id))
      duplicate_occupation.should_not be_valid
    end
  
    it "should not have a duplicate occupation up to case" do
      duplicate_case_occupation = Occupation.new(@attr.merge(:occupation => "accountant", :created_by => @user.id))
      duplicate_case_occupation.should_not be_valid
    end
  
    it "should allow the creator to add more than one occupation" do
      duplicate_user_occupation = Occupation.new(@attr.merge(:occupation => "Business consultant", :created_by => @user.id))
      duplicate_user_occupation.should be_valid
    end
  end
end
