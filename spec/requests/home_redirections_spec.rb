require 'spec_helper'

describe "HomeRedirections" do
  
  describe "when not logged in" do
    
    it "should direct to the 'Home' page" do
      visit root_path
      response.should have_selector('title', :content => "Home")   
    end
  end
  
  describe "when logged in" do
  
    describe "as an administrator" do
      
      before(:each) do
        @user = Factory(:user, :admin => true)
        integration_sign_in(@user)
      end
    
      it "should redirect to the 'Admin Home' page" do
        visit root_path
        response.should have_selector('title', :content => "Admin Home")   
      end
    
      describe "as a non-administrator" do
    
      end
      
    end
  
  end
 
end
