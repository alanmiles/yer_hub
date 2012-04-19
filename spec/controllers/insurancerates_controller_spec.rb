require 'spec_helper'

describe InsuranceratesController do

  render_views
  
  before(:each) do
    @nationality = Factory(:nationality)
    @currency = Factory(:currency)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)  
  end
  
  describe "for non-logged-in users" do
     
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
        @attr = { :country_id => @country.id, :low_salary => 0, :high_salary => 2000,
                  :employer_nats => 11, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 0 }
      end

      it "should not create a new insurance rate" do
        lambda do
          post :create, :country_id => @country.id, :insurancerate => @attr
        end.should_not change(Insurancerate, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :country_id => @country.id, :insurancerate => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :country_id => @country.id, :insurancerate => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @insurancerate = Factory(:insurancerate, :country_id => @country.id)
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @insurancerate
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @insurancerate
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :country_id => @country.id, :low_salary => 0, :high_salary => 6000,
                  :employer_nats => 12, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 1 }
      end

      it "should not change the insurance rate's attributes" do
        put :update, :id => @insurancerate, :insurancerate => @attr
        @insurancerate.reload
        @insurancerate.high_salary.should_not  == @attr[:high_salary]
        @insurancerate.employee_expats.should_not == @attr[:employee_expats]
      end

      it "should redirect to the root path" do
        put :update, :id => @insurancerate, :insurancerate => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the insurance rate" do
        lambda do
          delete :destroy, :id => @insurancerate
        end.should_not change(Insurancerate, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @insurancerate
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
          @attr = { :country_id => @country.id, :low_salary => 0, :high_salary => 2000,
                  :employer_nats => 11, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 0 }
        end
        
        it "should redirect to the home page" do
          post :create, :country_id => @country.id, :insurancerate => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :country_id => @country.id, :insurancerate => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @insurancerate = Factory(:insurancerate, :country_id => @country.id)
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @insurancerate
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @insurancerate
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :country_id => @country.id, :low_salary => 0, :high_salary => 6000,
                  :employer_nats => 12, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 1 }
        end

        it "should not change the insurance rate's attributes" do
          put :update, :id => @insurancerate, :insurancerate => @attr
          @insurancerate.reload
          @insurancerate.high_salary.should_not  == @attr[:high_salary]
          @insurancerate.employee_expats.should_not == @attr[:employee_expats]
        end

        it "should redirect to the root path" do
          put :update, :id => @insurancerate, :insurancerate => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the insurance rate" do
          lambda do
            delete :destroy, :id => @insurancerate
          end.should_not change(Insurancerate, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @insurancerate
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @insurancerate
          flash[:warning].should =~ /only available to administrators/i 
        end
      end
    end
    
    describe "admins" do
    
      before(:each) do
        @admin = Factory(:user, :admin => true)
        test_sign_in(@admin)
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new, :country_id => @country.id
          response.should be_success
        end
    
        it "should have the right title" do
          get :new, :country_id => @country.id
          response.should have_selector("title", :content => "New insurance rate")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :country_id => @country.id, :low_salary => nil, :high_salary => nil,
                  :employer_nats => 11, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 0 }
          end

          it "should not create an insurance rate" do
            lambda do
              post :create, :country_id => @country.id, :insurancerate => @attr
            end.should_not change(Currency, :count)
          end

          it "should have the right title" do
            post :create, :country_id => @country.id, :insurancerate => @attr
            response.should have_selector("title", :content => "New insurance rate")
          end

          it "should render the 'new' page" do
            post :create, :country_id => @country.id, :insurancerate => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :country_id => @country.id, :low_salary => 0, :high_salary => 2000,
                  :employer_nats => 11, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 0 }
        end

        it "should create an insurance rate" do
          lambda do
            post :create, :country_id => @country.id, :insurancerate => @attr
          end.should change(Insurancerate, :count).by(1)
        end
      
        it "should redirect to the insurance rules show page" do
          post :create, :country_id => @country.id, :insurancerate => @attr
          response.should redirect_to insurancerule_path(@country.insurancerule)
        end
      
        it "should have a success message" do
          post :create, :country_id => @country.id, :insurancerate => @attr
          flash[:success].should =~ /added new insurance rates/i
        end    
      end    
    
      describe "GET 'edit'" do

        before(:each) do
          @insurancerate = Factory(:insurancerate, :country_id => @country.id)
        end

        it "should be successful" do
          get :edit, :id => @insurancerate
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @insurancerate
          response.should have_selector("title", :content => "Edit insurance rate")
        end

        it "should permit changes to the insurance rate's low salary" do
          get :edit, :id => @insurancerate
          response.should have_selector("input", :name => "insurancerate[low_salary]")
        end

        it "should permit changes to the insurance rate's employer contribution for nationals" do
          get :edit, :id => @insurancerate
          response.should have_selector("input", :name => "insurancerate[employer_nats]")
        end
        
        it "should not permit changes to the insurance rate's country" do
          get :edit, :id => @insurancerate
          response.should_not have_selector("input", :name => "insurancerate[country_id]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @insurancerate
          response.should have_selector("input", :type => "submit", :value => "Update Insurance Rates")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @insurancerate = Factory(:insurancerate, :country_id => @country.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :low_salary => nil, :high_salary => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @insurancerate, :insurancerate => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @insurancerate, :insurancerate => @attr
            response.should have_selector("title", :content => "Edit insurance rate")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :low_salary => 4000, :high_salary => 8000 }   
          end

          it "should change the insurance rate's attributes" do
            put :update, :id => @insurancerate, :insurancerate => @attr
            @insurancerate.reload
            @insurancerate.low_salary.should  == @attr[:low_salary]
            @insurancerate.high_salary.should == @attr[:high_salary]
          end

          it "should redirect to the insurance rule show page" do
            put :update, :id => @insurancerate, :insurancerate => @attr
            response.should redirect_to insurancerule_path(@country.insurancerule)
          end

          it "should have a flash message" do
            put :update, :id => @insurancerate, :insurancerate => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @insurancerate = Factory(:insurancerate, :country_id => @country.id)
        end
        
        it "should destroy the insurance rate" do
          lambda do
            delete :destroy, :id => @insurancerate
          end.should change(Insurancerate, :count).by(-1)
        end
                   
        it "should confirm the deletion" do
          delete :destroy, :id => @insurancerate
          flash[:success].should =~ /successfully removed/i
        end
          
        it "should redirect to the country's insurance rule list" do
          delete :destroy, :id => @insurancerate
          response.should redirect_to insurancerule_path(@country.insurancerule)
        end      
      end
    end
  end

end
