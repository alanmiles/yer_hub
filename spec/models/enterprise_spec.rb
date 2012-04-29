# == Schema Information
#
# Table name: enterprises
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  short_name     :string(255)
#  address_1      :string(255)
#  address_2      :string(255)
#  address_3      :string(255)
#  town           :string(255)
#  district       :string(255)
#  zipcode        :string(255)
#  country_id     :integer
#  home_airport   :string(255)
#  sector_id      :string(255)
#  mission        :text
#  values         :text
#  terms_accepted :boolean         default(FALSE)
#  setup_step     :integer         default(1)
#  inactive       :boolean         default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Enterprise do
  
  before(:each) do
  
    @user = Factory(:user)
    @sector = Factory(:sector)
    @currency = Factory(:currency)
    @nationality = Factory(:nationality)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @abscat = Factory(:abscat, :approved => true)
    @attr =   { :name => "Business Company Limited", :short_name => "BizCo", :country_id => @country.id, :sector_id => @sector.id, :terms_accepted => true } 
  
  end

  it "should create a new instance given valid attributes" do
    Enterprise.create!(@attr)
  end
  
  it "should create a related record in the Business table simultaneously" do
    @enterprise = Enterprise.create(@attr)
    Business.count.should == 1
  end
  
  it "should create a related Enterpriseparameter table simultaneously" do
    @enterprise = Enterprise.create(@attr)
    Enterpriseparameter.count.should == 1
  end

  it "should create a related Bizparameter table simultaneously" do
    @enterprise = Enterprise.create(@attr)
    Bizparameter.count.should == 1
  end
  
  it "should automatically create a skeleton set of enterprise absence definitions" do
    @enterprise = Enterprise.create(@attr)
    Entabsencedef.count.should_not == 0
  end
  
  it "should automatically create a skeleton set of business absence definitions" do
    @enterprise = Enterprise.create(@attr)
    Bizabsencedef.count.should_not == 0
  end
 
  it "should require a name" do
    no_name_enterprise = Enterprise.new(@attr.merge(:name => ""))
    no_name_enterprise.should_not be_valid
  end
  
  it "should have a name of less than 51 characters" do
    @enterprise_name = "a" * 51
    long_name_enterprise = Enterprise.new(@attr.merge(:name => @enterprise_name))
    long_name_enterprise.should_not be_valid
  end
  
  it "should require a short_name" do
    no_shortname_enterprise = Enterprise.new(@attr.merge(:short_name => ""))
    no_shortname_enterprise.should_not be_valid
  end
  
  it "should have a short_name of less than 10 characters" do
    @enterprise_name = "a" * 11
    long_shortname_enterprise = Enterprise.new(@attr.merge(:short_name => @enterprise_name))
    long_shortname_enterprise.should_not be_valid
  end
  
  it "should require a country_id" do
    no_country_enterprise = Enterprise.new(@attr.merge(:country_id => nil))
    no_country_enterprise.should_not be_valid
  end
  
  it "should require a sector_id" do
    no_sector_enterprise = Enterprise.new(@attr.merge(:sector_id => nil))
    no_sector_enterprise.should_not be_valid
  end
  
  it "should not have a long home_airport name" do
    @airport_name = "a" * 31
    long_airport_enterprise = Enterprise.new(@attr.merge(:home_airport => @airport_name))
    long_airport_enterprise.should_not be_valid
  end
 
  describe "duplication rules" do
  
    before(:each) do
      @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
      @nationality2 = Factory(:nationality, :nationality => "British")
      @country2 = Factory(:country, :country => "Grosland", :nationality_id => @nationality2.id, :currency_id => @currency2.id) 
    end
     
    it "should not accept a duplicate_name in the same country" do
      Enterprise.create!(@attr)
      duplicate_name_country_enterprise = Enterprise.new(@attr.merge(:short_name => "short"))
      duplicate_name_country_enterprise.should_not be_valid
    end
    
    it "should not accept a duplicate name in the same country, including case shifts" do
      Enterprise.create!(@attr)
      duplicate_name_country_enterprise = Enterprise.new(@attr.merge(:name => "business company limited"))
      duplicate_name_country_enterprise.should_not be_valid
    end
    
    it "should accept a duplicate enterprise name in a different country" do
      Enterprise.create!(@attr)
      non_duplicate_enterprise = Enterprise.new(@attr.merge(:country_id => @country2.id))
      non_duplicate_enterprise.should be_valid
    end
  end
  
  describe "if terms are not accepted" do

    it "should not create a related Enterpriseparameter table simultaneously" do
      @enterprise = Enterprise.create(@attr.merge(:terms_accepted => false))
      Enterpriseparameter.count.should == 0
    end
  
    it "should create a related record in the Business table simultaneously" do
      Enterprise.create(@attr.merge(:terms_accepted => false))
      Business.count.should == 0
    end 
  
    it "should not automatically create a skeleton set of enterprise absence definitions" do
      @enterprise = Enterprise.create(@attr.merge(:terms_accepted => false))
      Entabsencedef.count.should == 0
    end
  end
end
