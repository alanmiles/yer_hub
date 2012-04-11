require 'spec_helper'

describe CurrenciesController do

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
        @attr = { :currency => "Bahraini Dinar", :abbreviation => "BHD",
                 :dec_places => 3, :created_by => 1 }
      end

      it "should not create a new currency" do
        lambda do
          post :create, :currency => @attr
        end.should_not change(Currency, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :currency => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :currency => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @user = Factory(:user)
      @currency = Factory(:currency, :created_by => @user.id)
    end
    
    describe "GET 'show'" do
    
      it "should not be successful" do
        get :show, :id => @currency
        response.should_not be_success
      end
        
      it "should redirect to the signin page" do
        get :show, :id => @currency
        response.should redirect_to signin_path
      end   
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @currency
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @currency
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :currency => "US Dollars", :abbreviation => "USD",
                  :dec_places => 2, :created_by => @user.id, :change_to_dollars => 1.00 }
      end

      it "should not change the currency's attributes" do
        put :update, :id => @currency, :currency => @attr
        @currency.reload
        @currency.currency.should_not  == @attr[:currency]
        @currency.abbreviation.should_not == @attr[:abbreviation]
      end

      it "should redirect to the root path" do
        put :update, :id => @currency, :currency => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the currency" do
        lambda do
          delete :destroy, :id => @currency
        end.should_not change(Currency, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @currency
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
          @attr = { :currency => "Bahraini Dinar", :abbreviation => "BHD",
                 :dec_places => 3, :created_by => 1 }
        end
        
        it "should redirect to the home page" do
          post :create, :currency => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :currency => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @currency = Factory(:currency, :created_by => @user.id)
      end
      
      describe "GET 'show'" do  

        it "should not be successful" do
          get :show, :id => @currency
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :show, :id => @currency
          response.should redirect_to root_path
        end   
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @currency
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @currency
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :currency => "US Dollars", :abbreviation => "USD",
                  :dec_places => 2, :created_by => @user.id, :change_to_dollars => 1.00 }
        end

        it "should not change the currency's attributes" do
          put :update, :id => @currency, :currency => @attr
          @currency.reload
          @currency.currency.should_not  == @attr[:currency]
          @currency.abbreviation.should_not == @attr[:abbreviation]
        end

        it "should redirect to the root path" do
          put :update, :id => @currency, :currency => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the currency" do
          lambda do
            delete :destroy, :id => @currency
          end.should_not change(Currency, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @currency
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @currency
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
      
        describe "with approval given" do
        
          before(:each) do
            @currency = Factory(:currency, :created_by => @admin.id, :approved => true)
            @currency1 = Factory(:currency, :currency => "Kuwaiti Dinar", :abbreviation => "KWD", :dec_places => 3, :change_to_dollars => 1.5,
          	:approved => true, :created_by => @admin.id)
            @currencies = [@currency, @currency1]
          end
        
          it "should be successful" do
            get :index
            response.should be_success
          end
    
          it "should have the right title" do
            get :index
            response.should have_selector("title", :content => "Currencies")
          end
        
          it "should have an element for each currency" do
            get :index
            @currencies.each do |currency|
              response.should have_selector("li", :content => currency.currency)
            end
          end
      
          it "should have a link to the 'edit' page for each currency" do
            get :index
            @currencies.each do |currency|
              response.should have_selector("a", :href => edit_currency_path(currency))
            end        
          end
        
          it "should not have an 'Approval' marker if approval has been given" do
            get :index
            @currencies.each do |currency|
              response.should_not have_selector("li", :content => "Approval?")
            end
          end
        
          it "should have a return button to the admin menu" do
            get :index
            response.should have_selector("a", :href => admin_home_path)
          end
        
          it "should have a link to the 'new' page" do
            get :index
            response.should have_selector("a", :href => new_currency_path)
          end       
        
        end
        
        describe "where approvals are required" do
        
          before(:each) do
            @currency = Factory(:currency, :created_by => @admin.id, :approved => false)
            @currency1 = Factory(:currency, :currency => "Kuwaiti Dinar", :abbreviation => "KWD", :dec_places => 3, :change_to_dollars => 1.5,
          	:approved => false, :created_by => @admin.id)
            @currencies = [@currency, @currency1]
          end
          
          it "should show where approvals are required - and give a link to the edit page" do
            get :index
            @currencies.each do |currency|
              response.should have_selector("a", :href => edit_currency_path(currency),
              					:content => "Approval?")
            end
          end
        
          it "should include a delete link if the currency is not linked to a country"
        
        end 
        
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new
          response.should be_success
        end
    
        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New currency")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :currency => "", :abbreviation => "", :dec_places => nil,
                  :created_by => nil }
          end

          it "should not create a currency" do
            lambda do
              post :create, :currency => @attr
            end.should_not change(Currency, :count)
          end

          it "should have the right title" do
            post :create, :currency => @attr
            response.should have_selector("title", :content => "New currency")
          end

          it "should render the 'new' page" do
            post :create, :currency => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :currency => "Bahraini Dinar", :abbreviation => "BHD",
                  :dec_places => 3, :created_by => @admin.id }
        end

        it "should create a currency" do
          lambda do
            post :create, :currency => @attr
          end.should change(Currency, :count).by(1)
        end
      
        it "should redirect to the currency show page" do
          post :create, :currency => @attr
          response.should redirect_to(currency_path(assigns(:currency)))
        end
      
        it "should have a success message" do
          post :create, :currency => @attr
          flash[:success].should =~ /added a new currency/i
        end    
      end    
    
      describe "GET 'show'" do
    
        before(:each) do
          @currency = Factory(:currency, :created_by => @admin.id)
        end

        it "should be successful" do
          get :show, :id => @currency
          response.should be_success
        end

        it "should find the right currency" do
          get :show, :id => @currency
          assigns(:currency).should == @currency
        end
    
        it "should have the right title" do
          get :show, :id => @currency
          response.should have_selector("title", :content => "Currency")
        end
        
        it "should have a link to the currency's edit page" do
          get :show, :id => @currency
          response.should have_selector("a", :href => edit_currency_path(@currency))
        end
        
        it "should have a link to the currency list" do
          get :show, :id => @currency
          response.should have_selector("a", :href => currencies_path)
        end
      end
      
      describe "GET 'edit'" do

        before(:each) do
          @currency = Factory(:currency, :created_by => @admin.id)
        end

        it "should be successful" do
          get :edit, :id => @currency
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @currency
          response.should have_selector("title", :content => "Edit currency")
        end

        it "should permit changes to the currency name" do
          get :edit, :id => @currency
          response.should have_selector("input", :name => "currency[currency]")
        end

        it "should permit changes to the abbreviation" do
          get :edit, :id => @currency
          response.should have_selector("input", :name => "currency[abbreviation]")
        end
        
        it "should permit changes to the number of decimal places" do
          get :edit, :id => @currency
          response.should have_selector("input", :name => "currency[dec_places]")
        end
        
        it "should allow changes to the 'change to dollars' rate" do
          get :edit, :id => @currency
          response.should have_selector("input", :name => "currency[change_to_dollars]")
        end
        
        it "should have approval checkboxes" do
          get :edit, :id => @currency
          response.should have_selector("input", :name => "currency[approved]")
        end
        
        it "should not permit changes to 'created_by'" do
          get :edit, :id => @currency
          response.should have_selector("input", :name => "currency[created_by]",
                                                 :type => "hidden")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @currency
          response.should have_selector("input", :type => "submit", :value => "Update Currency")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @currency = Factory(:currency, :created_by => @admin.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :currency => "", :abbreviation => "", :dec_places => nil,
                  :created_by => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @currency, :currency => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @currency, :currency => @attr
            response.should have_selector("title", :content => "Edit currency")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :currency => "US Dollars", :abbreviation => "USD",
                  :dec_places => 2, :created_by => @admin.id, :change_to_dollars => 1.00 }
          end

          it "should change the currency's attributes" do
            put :update, :id => @currency, :currency => @attr
            @currency.reload
            @currency.currency.should  == @attr[:currency]
            @currency.abbreviation.should == @attr[:abbreviation]
          end

          it "should redirect to the currency show page" do
            put :update, :id => @currency, :currency => @attr
            response.should redirect_to(currency_path(@currency))
          end

          it "should have a flash message" do
            put :update, :id => @currency, :currency => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @currency = Factory(:currency, :created_by => @admin.id)
        end
      
        describe "if currency is connected to a country" do
        
          it "should protect the currency"
          
          it "should redirect to the currency list"
          
          it "should explain why the deletion could not be made"
          
        end
        
        describe "if currency is unconnected" do
        
          it "should destroy the currency" do
            lambda do
              delete :destroy, :id => @currency
            end.should change(Currency, :count).by(-1)
          end
                   
          it "should confirm the deletion" do
            delete :destroy, :id => @currency
            flash[:success].should =~ /successfully removed/i
          end
          
          it "should redirect to the currency list" do
            delete :destroy, :id => @currency
            response.should redirect_to currencies_path
          end
        end      
      end
    end
  end
end
