# == Schema Information
#
# Table name: nationalities
#
#  id          :integer         not null, primary key
#  nationality :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Nationality do
  before(:each) do
    @attr =   { :nationality => "Chinese" }
  end

  it "should create a new instance given valid attributes" do
    Nationality.create!(@attr)
  end

  it "should require a nationality" do
    no_name_nationality = Nationality.new(@attr.merge(:nationality => ""))
    no_name_nationality.should_not be_valid
  end
  
  it "should have a nationality of less than 31 characters" do
    @nationality_name = "a" * 31
    long_name_nationality = Nationality.new(@attr.merge(:nationality => @nationality_name))
    long_name_nationality.should_not be_valid
  end
  
  describe "duplication" do
  
    before(:each) do
      Nationality.create!(@attr)
    end
  
    it "should not have a duplicate nationality" do
      duplicate_nationality = Nationality.new(@attr.merge(:nationality => "Chinese"))
      duplicate_nationality.should_not be_valid
    end
  
    it "should not have a duplicate currency up to case" do
      duplicate_case_nationality = Nationality.new(@attr.merge(:nationality => "chinese"))
      duplicate_case_nationality.should_not be_valid
    end
  end
end
