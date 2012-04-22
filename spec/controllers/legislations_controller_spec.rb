require 'spec_helper'

describe LegislationsController do

  render_views
  
  before(:each) do
    @nationality = Factory(:nationality, :nationality => "Greenish")
    @currency = Factory(:currency, :currency => "Greenback", :abbreviation => "GRN")
    @country = Factory(:country, :country => "Gronland", :nationality_id => @nationality.id, :currency_id => @currency.id)  
    @legislation = Legislation.find_by_country_id(@country.id)
  end
  
  describe "for non-logged-in users" do
    
    describe "GET 'show'" do
        
      it "should not be successful" do
        get :show, :id => @legislation
        response.should_not be_success
      end
        
      it "should redirect to the signin page" do
        get :show, :id => @legislation
        response.should redirect_to signin_path
      end   
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @legislation
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @legislation
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do 
        @nationality2 = Factory(:nationality, :nationality => "British")
        @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
        @country2 = Factory(:country, :country => "United Kingdom", :currency_id => @currency2.id, :nationality_id => @nationality2.id) 
        @attr = { :country_id => @country2.id}
      end

      it "should not change the legislation attributes" do
        put :update, :id => @legislation, :legislation => @attr
        @legislation.reload
        @legislation.country_id.should_not  == @attr[:country_id]
      end

      it "should redirect to the root path" do
        put :update, :id => @legislation, :legislation => @attr
        response.should redirect_to root_path
      end
    end
  end
  
  describe "for logged-in users" do
  
    describe "non-admins" do
    
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
    
      describe "GET 'show'" do  

        it "should not be successful" do
          get :show, :id => @legislation
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :show, :id => @legislation
          response.should redirect_to root_path
        end   
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @legislation
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @legislation
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do 
          @nationality2 = Factory(:nationality, :nationality => "British")
          @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
          @country2 = Factory(:country, :country => "United Kingdom", :currency_id => @currency2.id, :nationality_id => @nationality2.id) 
          @attr = { :country_id => @country2.id}
        end

        it "should not change the legislation attributes" do
          put :update, :id => @legislation, :legislation => @attr
          @legislation.reload
          @legislation.country_id.should_not  == @attr[:country_id]
        end

        it "should redirect to the root path" do
          put :update, :id => @legislation, :legislation => @attr
          response.should redirect_to root_path
        end
      end
    end
    
    describe "admins" do
    
      before(:each) do
        @admin = Factory(:user, :admin => true)
        test_sign_in(@admin)
      end
      
      describe "GET 'show'" do

        it "should be successful" do
          get :show, :id => @legislation
          response.should be_success
        end

        it "should find the right legislation record" do
          get :show, :id => @legislation
          assigns(:legislation).should == @legislation
        end
    
        it "should have the right title" do
          get :show, :id => @legislation
          response.should have_selector("title", :content => "Other country rules")
        end
        
        it "should have a link to the legislation edit page" do
          get :show, :id => @legislation
          response.should have_selector("a", :href => edit_legislation_path(@legislation))
        end
        
        it "should have a link to the countries list page" do
          get :show, :id => @legislation
          response.should have_selector("a", :href => countries_path)
        end
        
      end
      
      describe "GET 'edit'" do

        it "should be successful" do
          get :edit, :id => @legislation
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @legislation
          response.should have_selector("title", :content => "Edit country rules")
        end

        it "should not permit changes to the legislation country" do
          get :edit, :id => @legislation
          response.should_not have_selector("select", :name => "legislation[country_id]")
        end
         
        it "should permit changes to the male retirement age" do
          get :edit, :id => @legislation
          response.should have_selector("input", :name => "legislation[retirement_men]")
        end
        
        it "should permit changes to the female retirement age" do
          get :edit, :id => @legislation
          response.should have_selector("input", :name => "legislation[retirement_women]")
        end
        
        it "should have a sickness_accruals checkbox" do
          get :edit, :id => @legislation
          response.should have_selector("input", :name => "legislation[sickness_accruals]")
        end
        
        it "should permit changes to the maximum sickness accrual days" do
          get :edit, :id => @legislation
          response.should have_selector("input", :name => "legislation[max_sickness_accrual]")
        end
        
        it "should permit changes to the number of probation days" do
          get :edit, :id => @legislation
          response.should have_selector("input", :name => "legislation[probation_days]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @legislation
          response.should have_selector("input", :type => "submit", :value => "Update Country Rules")
        end        
      end
      
      describe "PUT 'update'" do

        describe "failure" do

          before(:each) do
            @attr = { :retirement_men => 10 }
          end

          it "should render the 'edit' page" do
            put :update, :id => @legislation, :legislation => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @legislation, :legislation => @attr
            response.should have_selector("title", :content => "Edit country rules")
          end
          
        end

        describe "success" do

          before(:each) do 
            @nationality2 = Factory(:nationality, :nationality => "British")
            @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
            @country2 = Factory(:country, :country => "United Kingdom", :currency_id => @currency2.id, :nationality_id => @nationality2.id) 
            @attr = { :retirement_men => 70}
          end

          it "should change the country's legislation attributes" do
            put :update, :id => @legislation, :legislation => @attr
            @legislation.reload
            @legislation.retirement_men.should  == 70
          end

          it "should redirect to the legislation show page" do
            put :update, :id => @legislation, :legislation => @attr
            response.should redirect_to @legislation
          end

          it "should have a flash message" do
            put :update, :id => @legislation, :legislation => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
    end
  end

end
