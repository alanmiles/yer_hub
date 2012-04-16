require 'spec_helper'

describe InsurancerulesController do

  render_views
  
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
        @nationality = Factory(:nationality, :nationality => "Pakistani") 
        @currency = Factory(:currency, :currency => "Rupee", :abbreviation => "PRP")
        @country = Factory(:country, :country => "Pakistan", :nationality_id => @nationality.id, :currency_id => @currency.id)
        @attr = { :country_id => @country.id }
      end

      it "should not create a new insurance rule" do
        lambda do
          post :create, :insurancerule => @attr
        end.should_not change(Insurancerule, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :insurancerule => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :insurancerule => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @nationality = Factory(:nationality)
      @currency = Factory(:currency)
      @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
      @insurancerule = Factory(:insurancerule, :country_id => @country.id)
    end
    
    describe "GET 'show'" do
    
      it "should not be successful" do
        get :show, :id => @insurancerule
        response.should_not be_success
      end
        
      it "should redirect to the signin page" do
        get :show, :id => @insurancerule
        response.should redirect_to signin_path
      end   
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @insurancerule
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @insurancerule
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

      it "should not change the insurance rule's attributes" do
        put :update, :id => @insurancerule, :insurancerule => @attr
        @insurancerule.reload
        @insurancerule.country_id.should_not  == @attr[:country_id]
      end

      it "should redirect to the root path" do
        put :update, :id => @insurancerule, :insurancerule => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the insurance rule" do
        lambda do
          delete :destroy, :id => @insurancerule
        end.should_not change(Insurancerule, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @insurancerule
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
          @nationality = Factory(:nationality, :nationality => "Pakistani") 
          @currency = Factory(:currency, :currency => "Rupee", :abbreviation => "PRP")
          @country = Factory(:country, :country => "Pakistan", :nationality_id => @nationality.id, :currency_id => @currency.id)
          @attr = { :country_id => @country.id }
        end        
        
        it "should redirect to the home page" do
          post :create, :insurancerule => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :insurancerule => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @nationality = Factory(:nationality)
        @currency = Factory(:currency)
        @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
        @insurancerule = Factory(:insurancerule, :country_id => @country.id)
      end
      
      describe "GET 'show'" do  

        it "should not be successful" do
          get :show, :id => @insurancerule
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :show, :id => @insurancerule
          response.should redirect_to root_path
        end   
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @insurancerule
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @insurancerule
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

        it "should not change the insurance rule's attributes" do
          put :update, :id => @insurancerule, :insurancerule => @attr
          @insurancerule.reload
          @insurancerule.country_id.should_not  == @attr[:country_id]
        end

        it "should redirect to the root path" do
          put :update, :id => @insurancerule, :insurancerule => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the insurance rule" do
          lambda do
            delete :destroy, :id => @insurancerule
          end.should_not change(Insurancerule, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @insurancerule
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @insurancerule
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
          @nationality = Factory(:nationality)
          @currency = Factory(:currency)
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
          @insurancerule = Factory(:insurancerule, :country_id => @country.id)
          @nationality3 = Factory(:nationality, :nationality => "American")
          @currency3 = Factory(:currency, :currency => "US dollars", :abbreviation => "USD")
          @country3 = Factory(:country, :country => "USA", :nationality_id => @nationality3.id, :currency_id => @currency3.id)  
          @insurancerule3 = Factory(:insurancerule, :country_id => @country3.id)
          @insurancerules = [@insurancerule, @insurancerule3]
        end
        
        it "should be successful" do
          get :index
          response.should be_success
        end
    
        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "Insurance rules")
        end
        
        it "should have an element for each insurance rule" do
          get :index
          @insurancerules.each do |rule|
            response.should have_selector("li", :content => rule.country.country)
          end
        end
      
        it "should have a link to the 'edit' page for each country" do
          get :index
          @insurancerules.each do |rule|
            response.should have_selector("a", :href => edit_insurancerule_path(rule))
          end        
        end
        
        it "should have a return button to the admin menu" do
          get :index
          response.should have_selector("a", :href => admin_home_path)
        end
        
        it "should have a link to the 'new' page" do
          get :index
          response.should have_selector("a", :href => new_insurancerule_path)
        end       
       
        it "should include a delete link if the country has never been used"
        
      end
  
      describe "GET 'new'" do
      
        before(:each) do
          @nationality = Factory(:nationality)
          @currency = Factory(:currency)
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
        end
          
        it "should be successful" do
          get :new
          response.should be_success
        end
    
        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New insurance rule")
        end
        
        it "should offer select options to specify the insurance rule country" do
          get :new
          response.should have_selector("select", :name => "insurancerule[country_id]")
        end
        
        it "should include in the select list countries with rules not set" do
          get :new
          @country = Country.first
          response.should have_selector("option", :value => @country.id.to_s)
        end
        
        it "should exclude countries with rules already set from the select list"
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :country_id => nil }
          end

          it "should not create an insurance rule" do
            lambda do
              post :create, :insurancerule => @attr
            end.should_not change(Insurancerule, :count)
          end

          it "should have the right title" do
            post :create, :insurancerule => @attr
            response.should have_selector("title", :content => "New insurance rule")
          end

          it "should render the 'new' page" do
            post :create, :insurancerule => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @nationality = Factory(:nationality)
          @currency = Factory(:currency)
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
          @attr = { :country_id => @country.id }
        end

        it "should create an insurance rule" do
          lambda do
            post :create, :insurancerule => @attr
          end.should change(Insurancerule, :count).by(1)
        end
      
        it "should redirect to the insurance rule show page" do
          post :create, :insurancerule => @attr
          response.should redirect_to(insurancerule_path(assigns(:insurancerule)))
        end
      
        it "should have a success message" do
          post :create, :insurancerule => @attr
          flash[:success].should =~ /added a new insurance rule/i
        end    
      end    
    
      describe "GET 'show'" do
    
        before(:each) do
          @nationality = Factory(:nationality)
          @currency = Factory(:currency)
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
          @insurancerule = Factory(:insurancerule, :country_id => @country.id)
        end

        it "should be successful" do
          get :show, :id => @insurancerule
          response.should be_success
        end

        it "should find the right insurance rule" do
          get :show, :id => @insurancerule
          assigns(:insurancerule).should == @insurancerule
        end
    
        it "should have the right title" do
          get :show, :id => @insurancerule
          response.should have_selector("title", :content => "Insurance rule")
        end
        
        it "should have a link to the insurance rule's edit page" do
          get :show, :id => @insurancerule
          response.should have_selector("a", :href => edit_insurancerule_path(@insurancerule))
        end
        
        it "should have a link to the insurance rule list" do
          get :show, :id => @insurancerule
          response.should have_selector("a", :href => insurancerules_path)
        end
      end
      
      describe "GET 'edit'" do

        before(:each) do
          @nationality = Factory(:nationality)
          @currency = Factory(:currency)
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
          @insurancerule = Factory(:insurancerule, :country_id => @country.id)
        end

        it "should be successful" do
          get :edit, :id => @insurancerule
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @insurancerule
          response.should have_selector("title", :content => "Edit insurance rule")
        end

        it "should permit changes to the insurance rule country" do
          get :edit, :id => @insurancerule
          response.should have_selector("select", :name => "insurancerule[country_id]")
        end
         
        it "should exclude countries with rules already set - except the current country - from the list"

        it "should permit changes to the salary ceiling" do
          get :edit, :id => @insurancerule
          response.should have_selector("input", :name => "insurancerule[salary_ceiling]")
        end
        
        it "should permit changes to the startend_date" do
          get :edit, :id => @insurancerule
          response.should have_selector("input", :name => "insurancerule[startend_date]")
        end
        
        it "should have a startend_prorate checkbox" do
          get :edit, :id => @insurancerule
          response.should have_selector("input", :name => "insurancerule[startend_prorate]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @insurancerule
          response.should have_selector("input", :type => "submit", :value => "Update Insurance Rule")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @nationality = Factory(:nationality)
          @currency = Factory(:currency)
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
          @insurancerule = Factory(:insurancerule, :country_id => @country.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :country_id => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @insurancerule, :insurancerule => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @insurancerule, :insurancerule => @attr
            response.should have_selector("title", :content => "Edit insurance rule")
          end
          
          it "should renew the list of countries to set for insurance rules" do
            get :update, :id => @insurancerule, :insurancerule => @attr
            response.should have_selector("select", :name => "insurancerule[country_id]")
          end
         
          it "should exclude countries with rules already set - except the current country - from the list"

        end

        describe "success" do

          before(:each) do 
            @nationality2 = Factory(:nationality, :nationality => "British")
            @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
            @country2 = Factory(:country, :country => "United Kingdom", :currency_id => @currency2.id, :nationality_id => @nationality2.id) 
            @attr = { :country_id => @country2.id}
          end

          it "should change the insurance rule's attributes" do
            put :update, :id => @insurancerule, :insurancerule => @attr
            @insurancerule.reload
            @insurancerule.country_id.should  == @attr[:country_id]
          end

          it "should redirect to the insurance rule show page" do
            put :update, :id => @insurancerule, :insurancerule => @attr
            response.should redirect_to(insurancerule_path(@insurancerule))
          end

          it "should have a flash message" do
            put :update, :id => @insurancerule, :insurancerule => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @nationality = Factory(:nationality)
          @currency = Factory(:currency)
          @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
          @insurancerule = Factory(:insurancerule, :country_id => @country.id)
        end
      
        describe "if insurance rule is in use" do
        
          it "should protect the insurance"
          
          it "should redirect to the insurance rule list"
          
          it "should explain why the deletion could not be made"
          
        end
        
        describe "if insurance rule is unconnected" do
        
          it "should destroy the insurance rule" do
            lambda do
              delete :destroy, :id => @insurancerule
            end.should change(Insurancerule, :count).by(-1)
          end
                   
          it "should confirm the deletion" do
            delete :destroy, :id => @insurancerule
            flash[:success].should =~ /successfully removed/i
          end
          
          it "should redirect to the insurance rule list" do
            delete :destroy, :id => @insurancerule
            response.should redirect_to insurancerules_path
          end
        end      
      end
    end
  end

end
