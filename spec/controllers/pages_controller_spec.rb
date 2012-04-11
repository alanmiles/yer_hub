require 'spec_helper'

describe PagesController do

  render_views
  
  describe "GET 'home'" do
    it "should be successful" do
      get :home
      response.should be_success
    end
    
    it "should have the right title" do
      get :home
      response.should have_selector("title",
                    :content => "Yer Hub | Home")
    end
  end

  describe "GET 'admin home'" do
    
    describe "when user is not signed in" do
      
      it "should not be successful" do
        get :admin_home
        response.should_not be_success
      end
    end
    
    describe "when signed-in user is not an admin" do
      
      before(:each) do
        test_sign_in(Factory(:user))
      end
      
      it "should not be successful" do
        get :admin_home
        response.should_not be_success
      end 
    end
    
    describe "when signed-in user is an admin" do
    
      before(:each) do
        @admin = Factory(:user, :admin => true)
        test_sign_in(@admin)
      end
      
      it "should be successful" do
        get :admin_home
        response.should be_success
      end 
    
      it "should have the right title" do
        get :admin_home
        response.should have_selector("title", :content => "Admin Home")
      end
    end
  
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get :contact
      response.should be_success
    end
    
    it "should have the right title" do
      get :contact
      response.should have_selector("title",
                        :content =>
                          "Yer Hub | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get :about
      response.should be_success
    end
    
    it "should have the right title" do
      get :about
      response.should have_selector("title",
                        :content =>
                          "Yer Hub | About")
    end
  end
end
