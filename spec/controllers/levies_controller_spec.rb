require 'spec_helper'

describe LeviesController do

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
        @attr = { :name => "BCDE", :country_id => @country.id, :low_salary => 0, :high_salary => 2000,
                  :employer_nats => 11, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 0 }
      end

      it "should not create a new insurance rate" do
        lambda do
          post :create, :country_id => @country.id, :levy => @attr
        end.should_not change(Insurancerate, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :country_id => @country.id, :levy => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :country_id => @country.id, :levy => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @levy = Factory(:levy, :country_id => @country.id)
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @levy
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @levy
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :country_id => @country.id, :name => "CDEF", :low_salary => 0, :high_salary => 6000,
                  :employer_nats => 12, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 1 }
      end

      it "should not change the levy's attributes" do
        put :update, :id => @levy, :levy => @attr
        @levy.reload
        @levy.high_salary.should_not  == @attr[:high_salary]
        @levy.employee_expats.should_not == @attr[:employee_expats]
      end

      it "should redirect to the root path" do
        put :update, :id => @levy, :levy => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the levy" do
        lambda do
          delete :destroy, :id => @levy
        end.should_not change(Levy, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @levy
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
          @attr = { :name => "BCDE", :country_id => @country.id, :low_salary => 0, :high_salary => 2000,
                  :employer_nats => 11, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 0 }
        end
        
        it "should redirect to the home page" do
          post :create, :country_id => @country.id, :levy => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :country_id => @country.id, :levy => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @levy = Factory(:levy, :country_id => @country.id)
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @levy
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @levy
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :country_id => @country.id, :name => "CDEF", :low_salary => 0, :high_salary => 6000,
                  :employer_nats => 12, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 1 }
        end

        it "should not change the levy's attributes" do
          put :update, :id => @levy, :levy => @attr
          @levy.reload
          @levy.high_salary.should_not  == @attr[:high_salary]
          @levy.employee_expats.should_not == @attr[:employee_expats]
        end

        it "should redirect to the root path" do
          put :update, :id => @levy, :levy => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the levy" do
          lambda do
            delete :destroy, :id => @levy
          end.should_not change(Levy, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @levy
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @levy
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
          response.should have_selector("title", :content => "New levy")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :country_id => @country.id, :name => nil, :low_salary => nil, :high_salary => nil,
                  :employer_nats => 11, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 0 }
          end

          it "should not create a levy" do
            lambda do
              post :create, :country_id => @country.id, :levy => @attr
            end.should_not change(Levy, :count)
          end

          it "should have the right title" do
            post :create, :country_id => @country.id, :levy => @attr
            response.should have_selector("title", :content => "New levy")
          end

          it "should render the 'new' page" do
            post :create, :country_id => @country.id, :levy => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :name => "BCDE", :country_id => @country.id, :low_salary => 0, :high_salary => 2000,
                  :employer_nats => 11, :employer_expats => 3, :employee_nats => 6, 
                  :employee_expats => 0 }
        end

        it "should create a levy" do
          lambda do
            post :create, :country_id => @country.id, :levy => @attr
          end.should change(Levy, :count).by(1)
        end
      
        it "should redirect to the legislation show page" do
          post :create, :country_id => @country.id, :levy => @attr
          response.should redirect_to legislation_path(@country.legislation)
        end
      
        it "should have a success message" do
          post :create, :country_id => @country.id, :levy => @attr
          flash[:success].should =~ /added a new levy/i
        end    
      end    
    
      describe "GET 'edit'" do

        before(:each) do
          @levy = Factory(:levy, :country_id => @country.id)
        end

        it "should be successful" do
          get :edit, :id => @levy
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @levy
          response.should have_selector("title", :content => "Edit levy")
        end
        
        it "should permit changes to the levy's name" do
          get :edit, :id => @levy
          response.should have_selector("input", :name => "levy[name]")
        end

        it "should permit changes to the levy's low salary" do
          get :edit, :id => @levy
          response.should have_selector("input", :name => "levy[low_salary]")
        end

        it "should permit changes to the levy's employer contribution for nationals" do
          get :edit, :id => @levy
          response.should have_selector("input", :name => "levy[employer_nats]")
        end
        
        it "should not permit changes to the levy's country" do
          get :edit, :id => @levy
          response.should_not have_selector("input", :name => "levy[country_id]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @levy
          response.should have_selector("input", :type => "submit", :value => "Update Levy")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @levy = Factory(:levy, :country_id => @country.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :low_salary => nil, :high_salary => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @levy, :levy => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @levy, :levy => @attr
            response.should have_selector("title", :content => "Edit levy")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :low_salary => 4000, :high_salary => 8000 }   
          end

          it "should change the levy's attributes" do
            put :update, :id => @levy, :levy => @attr
            @levy.reload
            @levy.low_salary.should  == @attr[:low_salary]
            @levy.high_salary.should == @attr[:high_salary]
          end

          it "should redirect to the legislation show page" do
            put :update, :id => @levy, :levy => @attr
            response.should redirect_to legislation_path(@country.legislation)
          end

          it "should have a flash message" do
            put :update, :id => @levy, :levy => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @levy = Factory(:levy, :country_id => @country.id)
        end
        
        it "should destroy the levy" do
          lambda do
            delete :destroy, :id => @levy
          end.should change(Levy, :count).by(-1)
        end
                   
        it "should confirm the deletion" do
          delete :destroy, :id => @levy
          flash[:success].should =~ /successfully removed/i
        end
          
        it "should redirect to the country's legislation list" do
          delete :destroy, :id => @levy
          response.should redirect_to legislation_path(@country.legislation)
        end      
      end
    end
  end


end
