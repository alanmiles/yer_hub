require 'spec_helper'

describe "AdminLinks" do
  
  before(:each) do
    @admin = Factory(:user, :admin => true)
    integration_sign_in(@admin)
  end
  
  it "should have the correct links" do
    visit root_path
    click_link "Currencies"
    response.should have_selector('title', :content => "Currencies")
    click_link "Notes"
    response.should have_selector('title', :content => "Notes")   
  
  end
end
