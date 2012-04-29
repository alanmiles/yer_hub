# == Schema Information
#
# Table name: businesses
#
#  id            :integer         not null, primary key
#  enterprise_id :integer
#  business_name :string(255)
#  short_name    :string(255)
#  address_1     :string(255)
#  address_2     :string(255)
#  address_3     :string(255)
#  town          :string(255)
#  district      :string(255)
#  zipcode       :string(255)
#  country_id    :integer
#  home_airport  :string(255)
#  sector_id     :integer
#  mission       :text
#  values        :text
#  share_mission :boolean         default(FALSE)
#  setup_step    :integer         default(1)
#  inactive      :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Business do
  
  before(:each) do
    
    @abscat = Factory(:abscat, :approved => true)  
    @sector = Factory(:sector)
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @enterprise = Factory(:enterprise, :country_id => @country.id, :sector_id => @sector.id)
   
  end

  it "should already have a business with the same name as the enterprise" do
    Business.where("business_name = ?", @enterprise.name).count.should == 1
  end
  
  it "should already have a related Bizparameter table" do
    @business = Business.where("business_name = ?", @enterprise.name)
    @parameters = Bizparameter.where("business_id = ?", @business)
    @parameters.count.should == 1
  end
  
  it "should already have a related BizAbsenceDef table" do
    @business = Business.where("business_name = ?", @enterprise.name)
    @defs = Bizabsencedef.where("business_id = ?", @business)
    @defs.count.should_not == 0
  end
  
  #simultaneous setup of Bizparameter and BizAbsencedef tables already checked in Enterprise model specs
  
  describe "when a second business is added to the enterprise" do
    
     before(:each) do
     
       @attr =   { :enterprise_id => @enterprise.id, :business_name => "New location", :short_name => "NewLoc",
    		 :country_id => @enterprise.country_id, :sector_id => @enterprise.sector.id } 
     end
      
     describe "successfully" do
     
       it "should create a business given valid parameters" do
         Business.create!(@attr)
       end
       
       it "should create a related Bizparameter table simultaneously" do
         @business = Business.create(@attr)
         Bizparameter.where("business_id = ?", @business).count.should == 1
       end
  
       it "should automatically create a skeleton set of business absence definitions" do
         @business = Business.create(@attr)
         Bizabsencedef.where("business_id = ?", @business).count.should_not == 0
       end
 
       it "should require a name" do
         no_name_business = Business.new(@attr.merge(:business_name => ""))
         no_name_business.should_not be_valid
       end
       
       it "should have a name of less than 51 characters" do
         @business_name = "a" * 51
         long_name_business = Business.new(@attr.merge(:business_name => @business_name))
         long_name_business.should_not be_valid
       end
  
       it "should require a short_name" do
         no_shortname_business = Business.new(@attr.merge(:short_name => ""))
         no_shortname_business.should_not be_valid
       end
  
       it "should have a short_name of less than 16 characters" do
         @abbreviation = "a" * 16
         long_shortname_business = Business.new(@attr.merge(:short_name => @abbreviation))
         long_shortname_business.should_not be_valid
       end
  
       it "should require a country_id" do
         no_country_business = Business.new(@attr.merge(:country_id => nil))
         no_country_business.should_not be_valid
       end
  
       it "should require a sector_id" do
         no_sector_business = Business.new(@attr.merge(:sector_id => nil))
         no_sector_business.should_not be_valid
       end
  
       it "should not have a long home_airport name" do
         @airport_name = "a" * 31
         long_airport_business = Enterprise.new(@attr.merge(:home_airport => @airport_name))
         long_airport_business.should_not be_valid
       end
 
       describe "duplication rules" do
  
         before(:each) do
           @enterprise2 = Factory(:enterprise, :name => "Another business", :short_name => "1more", :country_id => @country.id, :sector_id => @sector.id)
           @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
           @nationality2 = Factory(:nationality, :nationality => "British")
           @country2 = Factory(:country, :country => "Grosland", :nationality_id => @nationality2.id, :currency_id => @currency2.id) 
         end
     
         it "should not accept a duplicate_name in the same enterprise" do
           Business.create!(@attr)
           duplicate_name_enterprise_business = Business.new(@attr.merge(:short_name => "short"))
           duplicate_name_enterprise_business.should_not be_valid
         end
    
         it "should not accept a duplicate name in the same enterprise, including case shifts" do
           Business.create!(@attr)
           duplicate_name_enterprise_Business = Business.new(@attr.merge(:name => "new LOCATION"))
           duplicate_name_enterprise_Business.should_not be_valid
         end
    
         it "should accept a duplicate business name in a different enterprise" do
           Business.create!(@attr)
           non_duplicate_business = Business.new(@attr.merge(:enterprise_id => @enterprise2.id))
           non_duplicate_business.should be_valid
         end
       end
     end
     
     describe "unsuccessfully" do
     
       it "should not create a business given invalid parameters" do
         @newbiz = Business.create(@attr.merge(:business_name => @enterprise.name))
         @newbiz.should_not be_valid
       end
       
     end
  end
end
