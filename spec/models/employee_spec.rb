# == Schema Information
#
# Table name: employees
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  enterprise_id :integer
#  officer       :boolean         default(FALSE)
#  staff_id      :integer
#  left          :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Employee do
  
  before(:each) do
  
    @sector = Factory(:sector)
    @currency = Factory(:currency)
    @nationality = Factory(:nationality)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @user = Factory(:user, :email => "user@example.com")
    @enterprise = Factory(:enterprise, :country_id => @country.id, :sector_id => @sector.id, :created_by => @user.id) 
    
    @user2 = Factory(:user, :email => "user2@example.com")
    @enterprise2 = Factory(:enterprise, :name => "Enterprise 2", :short_name => "Ent2", :country_id => @country.id,
    			:sector_id => @sector.id, :created_by => @user2.id)
    @attr = { :user_id => @user2.id, :enterprise_id => @enterprise.id, :staff_id => 2 }
  end
  
  it "should already have an Employee table when an enterprise is created" do
    Employee.where("enterprise_id = ? and user_id = ?", @enterprise, @user).count.should == 1
  end
  
  it "should create a new employee given valid attributes" do
    @new_employee = Employee.new(@attr)
    @new_employee.should be_valid
  end
  
  it "should not allow a blank user_id" do
    @missing_user = Employee.new(@attr.merge(:user_id => nil))
    @missing_user.should_not be_valid
  end
  
  it "should not allow a blank enterprise_id" do
    @missing_enterprise = Employee.new(@attr.merge(:enterprise_id => nil))
    @missing_enterprise.should_not be_valid
  end
  
  it "should not have a blank staff_id" do
    @missing_number = Employee.new(@attr.merge(:staff_id => nil))
    @missing_number.should_not be_valid
  end
  
  it "should have a numeric staff_id" do
    @string_number = Employee.new(@attr.merge(:staff_id => "One"))
    @string_number.should_not be_valid
  end
  
  it "should not allow a duplicate user + enterprise combination" do
    @duplicate_employee = Employee.new(@attr.merge(:user_id => @user.id, :enterprise_id => @enterprise.id))
    @duplicate_employee.should_not be_valid
  end
  
  it "should allow a user to be an employee in a second enterprise" do
    @non_duplicate_employee = Employee.new(@attr.merge(:user_id => @user.id, :enterprise_id => @enterprise2.id))
    @non_duplicate_employee.should be_valid
  end
  
  it "should not permit a duplicate staff_id in the same enterprise" do
    @duplicate_staff_id = Employee.new(@attr.merge(:staff_id => 1))
  end
  
  it "should allow duplicate staff_ids in different enterprises" do
    @second_employee_ent1 = Employee.create(@attr)
    @second_employee_ent2 = Employee.create(@attr.merge(:user_id => @user.id, :enterprise_id => @enterprise2.id))
    @second_employee_ent2.should be_valid
  end
end
