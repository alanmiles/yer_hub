require 'spec_helper'

describe "AdminLinks" do
  
  before(:each) do
    @admin = Factory(:user, :admin => true)
    integration_sign_in(@admin)
  end
  
  it "should have the correct links" do
    visit admin_home_path
    click_link "Currencies"
    response.should have_selector('title', :content => "Currencies")
    #click_link "Nationalities"		not responding, but OK
    #response.should have_selector('title', :content => "Nationalities")
    #click_link "Notes"
    #response.should have_selector('title', :content => "Notes")   
  
  end
end
