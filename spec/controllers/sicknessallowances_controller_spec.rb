require 'spec_helper'

describe SicknessallowancesController do

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
        @attr = { :country_id => @country.id, :sick_days_from => 0, :sick_days_to => 15,
                  :deduction_rate => 0 }
      end

      it "should not create a new sickness allowance" do
        lambda do
          post :create, :country_id => @country.id, :sicknessallowance => @attr
        end.should_not change(Sicknessallowance, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :country_id => @country.id, :sicknessallowance => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :country_id => @country.id, :sicknessallowance => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @sicknessallowance = Factory(:sicknessallowance, :country_id => @country.id)
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @sicknessallowance
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @sicknessallowance
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :country_id => @country.id, :sick_days_from => 0, :sick_days_to => 15,
                  :deduction_rate => 0 }
      end

      it "should not change the sickness allowance's attributes" do
        put :update, :id => @sicknessallowance, :sicknessallowance => @attr
        @sicknessallowance.reload
        @sicknessallowance.sick_days_to.should_not  == @attr[:sick_days_to]
        @sicknessallowance.deduction_rate.should_not == @attr[:deduction_rate]
      end

      it "should redirect to the root path" do
        put :update, :id => @sicknessallowance, :sicknessallowance => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the sickness allowance" do
        lambda do
          delete :destroy, :id => @sicknessallowance
        end.should_not change(Sicknessallowance, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @sicknessallowance
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
           @attr = { :country_id => @country.id, :sick_days_from => 0, :sick_days_to => 15,
                  :deduction_rate => 0 }
        end
        
        it "should redirect to the home page" do
          post :create, :country_id => @country.id, :sicknessallowance => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :country_id => @country.id, :sicknessallowance => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @sicknessallowance = Factory(:sicknessallowance, :country_id => @country.id)
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @sicknessallowance
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @sicknessallowance
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :country_id => @country.id, :sick_days_from => 0, :sick_days_to => 15,
                  :deduction_rate => 0 }
        end

        it "should not change the sickness allowance's attributes" do
          put :update, :id => @sicknessallowance, :sicknessallowance => @attr
          @sicknessallowance.reload
          @sicknessallowance.sick_days_from.should_not  == @attr[:sick_days_from]
          @sicknessallowance.deduction_rate.should_not == @attr[:deduction_rate]
        end

        it "should redirect to the root path" do
          put :update, :id => @sicknessallowance, :sicknessallowance => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the sickness allowance" do
          lambda do
            delete :destroy, :id => @sicknessallowance
          end.should_not change(Sicknessallowance, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @sicknessallowance
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @sicknessallowance
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
            @sicknessallowance = Factory(:sicknessallowance, :country_id => @country.id)
            @sicknessallowance1 = Factory(:sicknessallowance, :country_id => @country.id, :sick_days_from => 0,
            	 :sick_days_to => 15, :deduction_rate => 0 )
            @sicknessallowances = [@sicknessallowance, @sicknessallowance1]
          end
        
          it "should be successful" do
            get :index, :country_id => @country.id
            response.should be_success
          end
    
          it "should have the right title" do
            get :index, :country_id => @country.id
            response.should have_selector("title", :content => "Sickness allowances")
          end
        
          it "should have an element for each set of allowances" do
            get :index, :country_id => @country.id
            @sicknessallowances.each do |sicknessallowance|
              response.should have_selector("td", :content => sicknessallowance.deduction_rate.to_s)
            end
          end
      
          it "should have a link to the 'edit' page for each set of allowances" do
            get :index, :country_id => @country.id
            @sicknessallowances.each do |sicknessallowance|
              response.should have_selector("a", :href => edit_sicknessallowance_path(sicknessallowance))
            end        
          end
          
          it "should include a delete link for each set of allowances" do
            get :index, :country_id => @country.id
            @sicknessallowances.each do |sicknessallowance|
              response.should have_selector("a", :href => sicknessallowance_path(sicknessallowance),             
              				"data-method" => "delete")
            end 
          end   
        
          it "should have a return button to the countries list page" do
            get :index, :country_id => @country.id
            response.should have_selector("a", :href => countries_path)
          end
        
          it "should have a link to the 'new' page" do
            get :index, :country_id => @country.id
            response.should have_selector("a", :href => new_country_sicknessallowance_path(@country))
          end       
      
        end
        
        describe "rates for a different country than the one selected" do
        
          before(:each) do
            @nationality2 = Factory(:nationality, :nationality => "Welsh")
            @currency2 = Factory(:currency, :currency => "Ingots", :abbreviation => "ING")
    	    @country2 = Factory(:country, :country => "Wales", :nationality_id => @nationality2.id, :currency_id => @currency2.id)  
	    @sicknessallowance = Factory(:sicknessallowance, :country_id => @country2.id)
            @sicknessallowance1 = Factory(:sicknessallowance, :country_id => @country2.id, :sick_days_from => 0,
            	 :sick_days_to => 15, :deduction_rate => 0)
            @sicknessallowances = [@sicknessallowance, @sicknessallowance1]
          end
          
          it "should not list the sickness allowances" do
            get :index, :country_id => @country.id
            @sicknessallowances.each do |sicknessallowance|
              response.should_not have_selector("td", :content => sicknessallowance.deduction_rate.to_s)
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
          response.should have_selector("title", :content => "New sickness allowances")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :country_id => @country.id, :sick_days_from => nil, :sick_days_to => nil,
                  :deduction_rate => nil }
          end

          it "should not create a sickness allowance" do
            lambda do
              post :create, :country_id => @country.id, :sicknessallowance => @attr
            end.should_not change(Sicknessallowance, :count)
          end

          it "should have the right title" do
            post :create, :country_id => @country.id, :sicknessallowance => @attr
            response.should have_selector("title", :content => "New sickness allowance")
          end

          it "should render the 'new' page" do
            post :create, :country_id => @country.id, :sicknessallowance => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :country_id => @country.id, :sick_days_from => 0, :sick_days_to => 15,
                  :deduction_rate => 0 }
        end

        it "should create a sickness allowance" do
          lambda do
            post :create, :country_id => @country.id, :sicknessallowance => @attr
          end.should change(Sicknessallowance, :count).by(1)
        end
      
        it "should redirect to the country's sickness allowance list page" do
          post :create, :country_id => @country.id, :sicknessallowance => @attr
          response.should redirect_to country_sicknessallowances_path(@country)
        end
      
        it "should have a success message" do
          post :create, :country_id => @country.id, :sicknessallowance => @attr
          flash[:success].should =~ /added a new sickness allowance/i
        end    
      end    
    
      describe "GET 'edit'" do

        before(:each) do
          @sicknessallowance = Factory(:sicknessallowance, :country_id => @country.id)
        end

        it "should be successful" do
          get :edit, :id => @sicknessallowance
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @sicknessallowance
          response.should have_selector("title", :content => "Edit sickness allowance")
        end

        it "should permit changes to the sickness allowance's 'sick_days_from' field" do
          get :edit, :id => @sicknessallowance
          response.should have_selector("input", :name => "sicknessallowance[sick_days_from]")
        end

        it "should permit changes to the sicknessallowance 's 'sick_days_to' field" do
          get :edit, :id => @sicknessallowance
          response.should have_selector("input", :name => "sicknessallowance[sick_days_to]")
        end
        
        it "should permit changes to the sickness allowance's 'deduction_rate' field" do
          get :edit, :id => @sicknessallowance
          response.should have_selector("input", :name => "sicknessallowance[deduction_rate]")
        end

        it "should not permit changes to the sickness allowance's country" do
          get :edit, :id => @sicknessallowance
          response.should_not have_selector("input", :name => "sicknessallowance[country_id]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @sicknessallowance
          response.should have_selector("input", :type => "submit", :value => "Update Sickness Allowance")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @sicknessallowance = Factory(:sicknessallowance, :country_id => @country.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :sick_days_from => nil, :sick_days_to => nil, :deduction_rate => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @sicknessallowance, :sicknessallowance => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @sicknessallowance, :sicknessallowance => @attr
            response.should have_selector("title", :content => "Edit sickness allowance")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :sick_days_from => 0, :sick_days_to => 15, :deduction_rate => 0  }
           end

          it "should change the sickness allowance's attributes" do
            put :update, :id => @sicknessallowance, :sicknessallowance => @attr
            @sicknessallowance.reload
            @sicknessallowance.sick_days_from  == @attr[:sick_days_from]
            @sicknessallowance.deduction_rate.should == @attr[:deduction_rate]
          end

          it "should redirect to the country sickness allowance index page" do
            put :update, :id => @sicknessallowance, :sicknessallowance => @attr
            response.should redirect_to country_sicknessallowances_path(@country)
          end

          it "should have a flash message" do
            put :update, :id => @sicknessallowance, :sicknessallowance => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @sicknessallowance = Factory(:sicknessallowance, :country_id => @country.id)
        end
        
        it "should destroy the sickness allowance" do
          lambda do
            delete :destroy, :id => @sicknessallowance
          end.should change(Sicknessallowance, :count).by(-1)
        end
                   
        it "should confirm the deletion" do
          delete :destroy, :id => @sicknessallowance
          flash[:success].should =~ /successfully removed/i
        end
          
        it "should redirect to the country's sickness allowance list" do
          delete :destroy, :id => @sicknessallowance
          response.should redirect_to country_sicknessallowances_path(@country)
        end      
      end
    end
  end

end
