# == Schema Information
#
# Table name: enterpriseparameters
#
#  id                   :integer         not null, primary key
#  enterprise_id        :integer
#  daily_salary_rate    :decimal(4, 2)   default(30.0)
#  hourly_salary_rate   :decimal(5, 2)   default(176.0)
#  ot_multiplier_1      :decimal(3, 2)   default(1.25)
#  ot_multiplier_2      :decimal(3, 2)   default(1.25)
#  ot_multiplier_3      :decimal(3, 2)   default(1.25)
#  standard_weekend_1   :integer         default(6)
#  standard_weekend_2   :integer         default(7)
#  vacation_calculation :boolean         default(FALSE)
#  payroll_close        :integer         default(15)
#  push_changes         :boolean         default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe Enterpriseparameter do
  
  before(:each) do
  
    @sector = Factory(:sector)
    @currency = Factory(:currency)
    @nationality = Factory(:nationality)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @enterprise = Factory(:enterprise, :country_id => @country.id, :sector_id => @sector.id)
  
  end
  
  it "should already have an Enterpriseparameter table" do
    Enterpriseparameter.where("enterprise_id = ?", @enterprise).count.should == 1
  end
  
  it "should not have a second record for the same enterprise" do
    @second_record = Enterpriseparameter.new(:enterprise_id => @enterprise.id)
    @second_record.should_not be_valid
  end
  
  it "should check that fields are not blank if not permitted"
  
end
