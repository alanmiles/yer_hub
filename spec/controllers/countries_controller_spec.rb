require 'spec_helper'

describe CountriesController do

  render_views
  
  before(:each) do
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country_name = "United Arab Emirates"
  end
  
  describe "for non-logged-in users" do
     
    describe "GET 'index'" do
      it "should_not be successful" do
        get :index
        response.should_not be_success
      end
      
      it "should redirect to the login path" do
        get :index
        response.should redirect_to signin_path
      end
    end
    
    describe "GET 'new'" do
      it "should not be successful" do
        get :new
        response.should_not be_success
      end
      
      it "should redirect to the login path" do
        get :new
        response.should redirect_to signin_path
      end
    end
    
    describe "POST 'create'" do
    
      before(:each) do
        @attr = { :country => @country_name, :nationality_id => @nationality.id,
                 :currency_id => @currency.id }
      end

      it "should not create a new country" do
        lambda do
          post :create, :country => @attr
        end.should_not change(Country, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :country => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :country => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @country
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @country
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @nationality2 = Factory(:nationality, :nationality => "Omani")
        @currency2 = Factory(:currency, :currency => "Omani Riyal", :abbreviation => "OMR", 
        			:dec_places => 3)
        @attr = { :country => "Oman", :nationality_id => @nationality2.id,
                  :currency_id => @currency2.id }
      end

      it "should not change the country's attributes" do
        put :update, :id => @country, :country => @attr
        @country.reload
        @country.country.should_not  == @attr[:country]
        @country.nationality_id.should_not == @attr[:nationality_id]
      end

      it "should redirect to the root path" do
        put :update, :id => @country, :country => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the country" do
        lambda do
          delete :destroy, :id => @country
        end.should_not change(Country, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @country
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
    
      describe "GET 'index'" do
        it "should not be successful" do
          get :index
          response.should_not be_success
        end
      end
      
      describe "GET 'new'" do
        it "should not be successful" do
          get :new
          response.should_not be_success
        end
      
        it "should redirect to the home page" do
          get :new
          response.should redirect_to root_path
        end
      end
      
      
      describe "POST 'create'" do
        
        before(:each) do
          @attr = { :country => @country_name, :nationality_id => @nationality.id,
                 :currency_id => @currency.id }
        end
        
        it "should redirect to the home page" do
          post :create, :country => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :country => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @country
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @country
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @nationality2 = Factory(:nationality, :nationality => "Omani")
          @currency2 = Factory(:currency, :currency => "Omani Riyal", :abbreviation => "OMR", 
        			:dec_places => 3)
          @attr = { :country => "Oman", :nationality_id => @nationality2.id,
                  :currency_id => @currency2.id }
        end

        it "should not change the country's attributes" do
          put :update, :id => @country, :country => @attr
          @country.reload
          @country.country.should_not  == @attr[:country]
          @country.nationality_id.should_not == @attr[:nationality_id]
        end

        it "should redirect to the root path" do
          put :update, :id => @country, :country => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the country" do
          lambda do
            delete :destroy, :id => @country
          end.should_not change(Country, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @country
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @country
          flash[:warning].should =~ /only available to administrators/i 
        end
      end
    end
    
    describe "admins" do
    
      before(:each) do
        @admin = Factory(:user, :admin => true)
        test_sign_in(@admin)
      end
      
      describe "GET 'index'" do
        
        before(:each) do
          @nationality2 = Factory(:nationality, :nationality => "Omani")
          @currency2 = Factory(:currency, :currency => "Omani Riyal", :abbreviation => "OMR", 
        			:dec_places => 3)
         
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
          @country2 = Factory(:country, :country => "Oman", :nationality_id => @nationality2.id, 
          				:currency_id => @currency2.id)
          @countries = [@country, @country2]
        end
        
        it "should be successful" do
          get :index
          response.should be_success
        end
    
        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "Countries")
        end
        
        it "should have an element for each country" do
          get :index
          @countries.each do |country|
            response.should have_selector("li", :content => country.country)
          end
        end
      
        it "should have a link to the 'edit' page for each country" do
          get :index
          @countries.each do |country|
            response.should have_selector("a", :href => edit_country_path(country))
          end        
        end
        
        it "should have a return button to the admin menu" do
          get :index
          response.should have_selector("a", :href => admin_home_path)
        end
        
        it "should have a link to the 'new' page" do
          get :index
          response.should have_selector("a", :href => new_country_path)
        end       
        
        it "should include a delete link if the country has never been used"
        
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new
          response.should be_success
        end
    
        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New country")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :country => "", :nationality_id => nil,
                  :currency_id => nil }
          end

          it "should not create a country" do
            lambda do
              post :create, :country => @attr
            end.should_not change(Country, :count)
          end

          it "should have the right title" do
            post :create, :country => @attr
            response.should have_selector("title", :content => "New country")
          end

          it "should render the 'new' page" do
            post :create, :country => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @nationality3 = Factory(:nationality, :nationality => "American")
          @currency3 = Factory(:currency, :currency => "US Dollars", :abbreviation => "USD", :dec_places => 2)
          @attr = { :country => "USA", :nationality_id => @nationality3.id,
                  :currency_id => @currency3.id }
        end

        it "should create a country" do
          lambda do
            post :create, :country => @attr
          end.should change(Country, :count).by(1)
        end
        
        it "should create associated insurance rules" do
          post :create, :country => @attr
          @country = Country.last
          @country.insurancerule.should be_valid
        end
      
        it "should redirect to the country index" do
          post :create, :country => @attr
          response.should redirect_to countries_path
        end
      
        it "should have a success message" do
          post :create, :country => @attr
          flash[:success].should =~ /added/i
        end    
      end    
      
      describe "GET 'edit'" do

        before(:each) do
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
        end

        it "should be successful" do
          get :edit, :id => @country
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @country
          response.should have_selector("title", :content => "Edit country")
        end

        it "should permit changes to the country name" do
          get :edit, :id => @country
          response.should have_selector("input", :name => "country[country]")
        end

        it "should permit changes to the home nationality" do
          get :edit, :id => @country
          response.should have_selector("select", :name => "country[nationality_id]")
        end
        
        it "should permit changes to the home currency" do
          get :edit, :id => @country
          response.should have_selector("select", :name => "country[currency_id]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @country
          response.should have_selector("input", :type => "submit", :value => "Update Country")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :country => "", :nationality_id => nil, :currency_id => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @country, :country => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @country, :country => @attr
            response.should have_selector("title", :content => "Edit country")
          end
        end

        describe "success" do

          before(:each) do
            @nationality3 = Factory(:nationality, :nationality => "American")
            @currency3 = Factory(:currency, :currency => "US Dollars", :abbreviation => "USD", :dec_places => 2)
            @attr = { :country => "USA", :nationality_id => @nationality3.id,
                  :currency_id => @currency3.id }
          end

          it "should change the country's attributes" do
            put :update, :id => @country, :country => @attr
            @country.reload
            @country.country.should  == @attr[:country]
            @country.nationality_id.should == @attr[:nationality_id]
          end

          it "should redirect to the countries index" do
            put :update, :id => @country, :country => @attr
            response.should redirect_to countries_path
          end

          it "should have a flash message" do
            put :update, :id => @country, :country => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
        end
      
        describe "if country has been used elsewhere" do
        
          it "should protect the country"
          
          it "should redirect to the country list"
          
          it "should explain why the deletion could not be made"
          
        end
        
        describe "if country is unconnected" do
        
          it "should destroy the country" do
            lambda do
              delete :destroy, :id => @country
            end.should change(Country, :count).by(-1)
          end
                   
          it "should confirm the deletion" do
            delete :destroy, :id => @country
            flash[:success].should =~ /successfully removed/i
          end
          
          it "should no longer have a valid insurance rule" do
            lambda do
              delete :destroy, :id => @country
            end.should change(Insurancerule, :count).by(-1)
          end
          
          it "should redirect to the country list" do
            delete :destroy, :id => @country
            response.should redirect_to countries_path
          end
        end      
      end
    end
  end

end
