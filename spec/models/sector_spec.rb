# == Schema Information
#
# Table name: sectors
#
#  id         :integer         not null, primary key
#  sector     :string(255)
#  approved   :boolean
#  created_by :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Sector do
  
  before(:each) do
    @user = Factory(:user)
    @attr =   { :sector => "Banking", 
      		:created_by => @user.id }
  end

  it "should create a new instance given valid attributes" do
    Sector.create!(@attr)
  end

  it "should require a sector name" do
    no_name_sector = Sector.new(@attr.merge(:sector => "", :created_by => @user.id))
    no_name_sector.should_not be_valid
  end
  
  it "should have a sector of less than 51 characters" do
    @sector_name = "a" * 51
    long_name_sector = Sector.new(@attr.merge(:sector => @sector_name, :created_by => @user.id))
    long_name_sector.should_not be_valid
  end
  
  it "should require a creator" do
    no_creator_sector = Sector.new(@attr.merge(:sector => "Business Consultancy", :created_by => nil))
    no_creator_sector.should_not be_valid
  end
  
  describe "duplication" do
  
    before(:each) do
      Sector.create!(@attr)
    end
  
    it "should not have a duplicate sector" do
      duplicate_sector = Sector.new(@attr.merge(:sector => "Banking", :created_by => @user.id))
      duplicate_sector.should_not be_valid
    end
  
    it "should not have a duplicate sector up to case" do
      duplicate_case_sector = Sector.new(@attr.merge(:sector => "banking", :created_by => @user.id))
      duplicate_case_sector.should_not be_valid
    end
  
    it "should allow the creator to add more than one sector" do
      duplicate_user_sector = Sector.new(@attr.merge(:sector => "Retail", :created_by => @user.id))
      duplicate_user_sector.should be_valid
    end
  end
end
