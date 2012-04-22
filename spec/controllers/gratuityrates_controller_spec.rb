require 'spec_helper'

describe GratuityratesController do

  render_views
  
  before(:each) do
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
  end
  
  describe "for non-logged-in users" do
    
    describe "GET 'index'" do
        
      it "should not be successful" do
        get :index, :country_id => @country.id
        response.should_not be_success
      end
        
      it "should redirect to the signin page" do
        get :index, :country_id => @country.id
        response.should redirect_to signin_path
      end   
    end
    
    describe "GET 'new'" do
      it "should not be successful" do
        get :new, :country_id => @country.id
        response.should_not be_success
      end
      
      it "should redirect to the login path" do
        get :new, :country_id => @country.id
        response.should redirect_to signin_path
      end
    end
    
    describe "POST 'create'" do
    
      before(:each) do
        @attr = { :country_id => @country.id, :service_years_from => 0, :service_years_to => 3,
                  :resignation_rate => 0, :non_resignation_rate => 50 }
      end

      it "should not create a new gratuity rate" do
        lambda do
          post :create, :country_id => @country.id, :gratuityrate => @attr
        end.should_not change(Gratuityrate, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :country_id => @country.id, :gratuityrate => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :country_id => @country.id, :gratuityrate => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @gratuityrate = Factory(:gratuityrate, :country_id => @country.id)
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @gratuityrate
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @gratuityrate
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :country_id => @country.id, :service_years_from => 0, :service_years_to => 3,
                  :resignation_rate => 0, :non_resignation_rate => 50 }
      end

      it "should not change the gratuity rate's attributes" do
        put :update, :id => @gratuityrate, :gratuityrate => @attr
        @gratuityrate.reload
        @gratuityrate.service_years_from.should_not  == @attr[:service_years_from]
        @gratuityrate.resignation_rate.should_not == @attr[:resignation_rate]
      end

      it "should redirect to the root path" do
        put :update, :id => @gratuityrate, :gratuityrate => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the gratuity rate" do
        lambda do
          delete :destroy, :id => @gratuityrate
        end.should_not change(Gratuityrate, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @gratuityrate
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
          get :index, :country_id => @country.id
          response.should_not be_success
        end
        
        it "should redirect to the signin page" do
          get :index, :country_id => @country.id
          response.should redirect_to root_path
        end   
      end
      
      describe "GET 'new'" do
        it "should not be successful" do
          get :new, :country_id => @country.id
          response.should_not be_success
        end
      
        it "should redirect to the home page" do
          get :new, :country_id => @country.id
          response.should redirect_to root_path
        end
      end
      
      
      describe "POST 'create'" do
        
        before(:each) do
           @attr = { :country_id => @country.id, :service_years_from => 0, :service_years_to => 3,
                  :resignation_rate => 0, :non_resignation_rate => 50 }
        end
        
        it "should redirect to the home page" do
          post :create, :country_id => @country.id, :gratuityrate => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :country_id => @country.id, :gratuityrate => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @gratuityrate = Factory(:gratuityrate, :country_id => @country.id)
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @gratuityrate
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @gratuityrate
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :country_id => @country.id, :service_years_from => 0, :service_years_to => 3,
                  :resignation_rate => 0, :non_resignation_rate => 50 }
        end

        it "should not change the gratuity rate's attributes" do
          put :update, :id => @gratuityrate, :gratuityrate => @attr
          @gratuityrate.reload
          @gratuityrate.service_years_from.should_not  == @attr[:service_years_from]
          @gratuityrate.resignation_rate.should_not == @attr[:resignation_rate]
        end

        it "should redirect to the root path" do
          put :update, :id => @gratuityrate, :gratuityrate => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the gratuity rate" do
          lambda do
            delete :destroy, :id => @gratuityrate
          end.should_not change(Gratuityrate, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @gratuityrate
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @gratuityrate
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
      
        describe "rates in selected country" do
        
          before(:each) do
            @gratuityrate = Factory(:gratuityrate, :country_id => @country.id)
            @gratuityrate1 = Factory(:gratuityrate, :country_id => @country.id, :service_years_from => 0,
            	 :service_years_to => 3, :resignation_rate => 0, :non_resignation_rate => 50)
            @gratuityrates = [@gratuityrate, @gratuityrate1]
          end
        
          it "should be successful" do
            get :index, :country_id => @country.id
            response.should be_success
          end
    
          it "should have the right title" do
            get :index, :country_id => @country.id
            response.should have_selector("title", :content => "Gratuity rates")
          end
        
          it "should have an element for each set of rates" do
            get :index, :country_id => @country.id
            @gratuityrates.each do |gratuityrate|
              response.should have_selector("td", :content => gratuityrate.resignation_rate.to_s)
            end
          end
      
          it "should have a link to the 'edit' page for each set of rates" do
            get :index, :country_id => @country.id
            @gratuityrates.each do |gratuityrate|
              response.should have_selector("a", :href => edit_gratuityrate_path(gratuityrate))
            end        
          end
          
          it "should include a delete link for each set of rates" do
            get :index, :country_id => @country.id
            @gratuityrates.each do |gratuityrate|
              response.should have_selector("a", :href => gratuityrate_path(gratuityrate),             
              				"data-method" => "delete")
            end 
          end   
        
          it "should have a return button to the countries list page" do
            get :index, :country_id => @country.id
            response.should have_selector("a", :href => countries_path)
          end
        
          it "should have a link to the 'new' page" do
            get :index, :country_id => @country.id
            response.should have_selector("a", :href => new_country_gratuityrate_path(@country))
          end       
      
        end
        
        describe "rates for a different country than the one selected" do
        
          before(:each) do
            @nationality2 = Factory(:nationality, :nationality => "Welsh")
            @currency2 = Factory(:currency, :currency => "Ingots", :abbreviation => "ING")
    	    @country2 = Factory(:country, :country => "Wales", :nationality_id => @nationality2.id, :currency_id => @currency2.id)  
	    @gratuityrate = Factory(:gratuityrate, :country_id => @country2.id)
            @gratuityrate1 = Factory(:gratuityrate, :country_id => @country2.id, :service_years_from => 0,
            	 :service_years_to => 3, :resignation_rate => 0, :non_resignation_rate => 50)
            @gratuityrates = [@gratuityrate, @gratuityrate1]
          end
          
          it "should not list the gratuity rates" do
            get :index, :country_id => @country.id
            @gratuityrates.each do |gratuityrate|
              response.should_not have_selector("td", :content => gratuityrate.resignation_rate.to_s)
            end
          end
        
        end 
        
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new, :country_id => @country.id
          response.should be_success
        end
    
        it "should have the right title" do
          get :new, :country_id => @country.id
          response.should have_selector("title", :content => "New gratuity rates")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :country_id => @country.id, :service_years_from => nil, :service_years_to => nil,
                  :resignation_rate => nil, :non_resignation_rate => nil }
          end

          it "should not create a gratuity rate" do
            lambda do
              post :create, :country_id => @country.id, :gratuityrate => @attr
            end.should_not change(Gratuityrate, :count)
          end

          it "should have the right title" do
            post :create, :country_id => @country.id, :gratuityrate=> @attr
            response.should have_selector("title", :content => "New gratuity rate")
          end

          it "should render the 'new' page" do
            post :create, :country_id => @country.id, :gratuityrate => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :country_id => @country.id, :service_years_from => 0, :service_years_to => 3,
                  :resignation_rate => 0, :non_resignation_rate => 50 }
        end

        it "should create a gratuity rate" do
          lambda do
            post :create, :country_id => @country.id, :gratuityrate => @attr
          end.should change(Gratuityrate, :count).by(1)
        end
      
        it "should redirect to the country's gratuity rate list page" do
          post :create, :country_id => @country.id, :gratuityrate => @attr
          response.should redirect_to country_gratuityrates_path(@country)
        end
      
        it "should have a success message" do
          post :create, :country_id => @country.id, :gratuityrate => @attr
          flash[:success].should =~ /added new gratuity rates/i
        end    
      end    
    
      describe "GET 'edit'" do

        before(:each) do
          @gratuityrate = Factory(:gratuityrate, :country_id => @country.id)
        end

        it "should be successful" do
          get :edit, :id => @gratuityrate
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @gratuityrate
          response.should have_selector("title", :content => "Edit gratuity rates")
        end

        it "should permit changes to the gratuity rate's 'service_years_from' field" do
          get :edit, :id => @gratuityrate
          response.should have_selector("input", :name => "gratuityrate[service_years_from]")
        end

        it "should permit changes to the gratuity rate's 'service_years_to' field" do
          get :edit, :id => @gratuityrate
          response.should have_selector("input", :name => "gratuityrate[service_years_to]")
        end
        
        it "should permit changes to the gratuity rate's 'resignation_rate' field" do
          get :edit, :id => @gratuityrate
          response.should have_selector("input", :name => "gratuityrate[resignation_rate]")
        end

        it "should permit changes to the gratuity rate's 'non_resignation_rate' field" do
          get :edit, :id => @gratuityrate
          response.should have_selector("input", :name => "gratuityrate[non_resignation_rate]")
        end
        
        it "should not permit changes to the gratuity rate's country" do
          get :edit, :id => @gratuityrate
          response.should_not have_selector("input", :name => "gratuityrate[country_id]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @gratuityrate
          response.should have_selector("input", :type => "submit", :value => "Update Gratuity Rates")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @gratuityrate = Factory(:gratuityrate, :country_id => @country.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :service_years_from => nil, :service_years_to => nil, :resignation_rate => nil, :non_resignation_rate => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @gratuityrate, :gratuityrate => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @gratuityrate, :gratuityrate => @attr
            response.should have_selector("title", :content => "Edit gratuity rate")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :service_years_from => 0, :service_years_to => 3, :resignation_rate => 0, :non_resignation_rate => 50 }
           end

          it "should change the gratuity rate's attributes" do
            put :update, :id => @gratuityrate, :gratuityrate => @attr
            @gratuityrate.reload
            @gratuityrate.service_years_from  == @attr[:service_years_from]
            @gratuityrate.resignation_rate.should == @attr[:resignation_rate]
          end

          it "should redirect to the country gratuity rates index page" do
            put :update, :id => @gratuityrate, :gratuityrate => @attr
            response.should redirect_to country_gratuityrates_path(@country)
          end

          it "should have a flash message" do
            put :update, :id => @gratuityrate, :gratuityrate => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @gratuityrate = Factory(:gratuityrate, :country_id => @country.id)
        end
        
        it "should destroy the gratuity rate" do
          lambda do
            delete :destroy, :id => @gratuityrate
          end.should change(Gratuityrate, :count).by(-1)
        end
                   
        it "should confirm the deletion" do
          delete :destroy, :id => @gratuityrate
          flash[:success].should =~ /successfully removed/i
        end
          
        it "should redirect to the country's gratuity rates list" do
          delete :destroy, :id => @gratuityrate
          response.should redirect_to country_gratuityrates_path(@country)
        end      
      end
    end
  end

end
