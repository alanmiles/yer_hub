require 'spec_helper'

describe InsurancerulesController do

  render_views
  
  before(:each) do
    @nationality = Factory(:nationality, :nationality => "Greenish")
    @currency = Factory(:currency, :currency => "Greenback", :abbreviation => "GRN")
    @country = Factory(:country, :country => "Gronland", :nationality_id => @nationality.id, :currency_id => @currency.id)  
    @insurancerule = Insurancerule.find_by_country_id(@country.id)
  end
  
  describe "for non-logged-in users" do
    
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
  end
  
  describe "for logged-in users" do
  
    describe "non-admins" do
    
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
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
    end
    
    describe "admins" do
    
      before(:each) do
        @admin = Factory(:user, :admin => true)
        test_sign_in(@admin)
      end
      
      describe "GET 'show'" do

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
          response.should have_selector("title", :content => "Insurance")
        end
        
        it "should have a link to the insurance rule's edit page" do
          get :show, :id => @insurancerule
          response.should have_selector("a", :href => edit_insurancerule_path(@insurancerule))
        end
        
        it "should have a link to the countries list page" do
          get :show, :id => @insurancerule
          response.should have_selector("a", :href => countries_path)
        end
        
        describe "showing insurance rates values" do
          
          describe "for the country selected" do
        
            before(:each) do
              @insurancerate = Factory(:insurancerate, :country_id => @country.id)
              @insurancerate2 = Factory(:insurancerate, :country_id => @country.id, :low_salary => 4000, 
               	:high_salary => 6000, :employer_nats => 13, :employee_nats => 8 )
              @insurancerates = [@insurancerate, @insurancerate2]
            end
        
            it "should have an element for each rate" do
              get :show, :id => @insurancerule
              @insurancerates.each do |rate|
                response.should have_selector("td", :content => rate.high_salary.to_s)
              end
            end
      
            it "should have a link to the 'edit' page for each insurance rate" do
              get :show, :id => @insurancerule
              @insurancerates.each do |rate|
                response.should have_selector("a", :href => edit_insurancerate_path(rate.id))
              end        
            end
        
            it "should have a link to the 'new' insurance rate page" do
              get :show, :id => @insurancerule
              response.should have_selector("a", :href => new_country_insurancerate_path(@country))
            end       
        
          end	
        
          describe "where insurance rates are not from the selected country" do
        
            before(:each) do
              @nationality2 = Factory(:nationality, :nationality => "British")
              @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
              @country2 = Factory(:country, :country => "United Kingdom", :currency_id => @currency2.id, :nationality_id => @nationality2.id) 
          
              @insurancerate = Factory(:insurancerate, :country_id => @country2)
              @insurancerate2 = Factory(:insurancerate, :country_id => @country2.id, :low_salary => 4000, 
             	:high_salary => 6000, :employer_nats => 13, :employee_nats => 8 )
              @insurancerates = [@insurancerate, @insurancerate2]
            end
          
            it "should have not have an element for each rate" do
              get :show, :id => @insurancerule
              @insurancerates.each do |rate|
                response.should_not have_selector("td", :content => rate.low_salary.to_s)
              end
            end
          end 
        end
        
      end
      
      describe "GET 'edit'" do

        it "should be successful" do
          get :edit, :id => @insurancerule
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @insurancerule
          response.should have_selector("title", :content => "Edit insurance rule")
        end

        it "should not permit changes to the insurance rule country" do
          get :edit, :id => @insurancerule
          response.should_not have_selector("select", :name => "insurancerule[country_id]")
        end
         
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

        describe "failure" do

          before(:each) do
            @attr = { :startend_date => 0 }
          end

          it "should render the 'edit' page" do
            put :update, :id => @insurancerule, :insurancerule => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @insurancerule, :insurancerule => @attr
            response.should have_selector("title", :content => "Edit insurance rule")
          end
          
        end

        describe "success" do

          before(:each) do 
            @nationality2 = Factory(:nationality, :nationality => "British")
            @currency2 = Factory(:currency, :currency => "Pound Sterling", :abbreviation => "GBP")
            @country2 = Factory(:country, :country => "United Kingdom", :currency_id => @currency2.id, :nationality_id => @nationality2.id) 
            @attr = { :salary_ceiling => 40000}
          end

          it "should change the insurance rule's attributes" do
            put :update, :id => @insurancerule, :insurancerule => @attr
            @insurancerule.reload
            @insurancerule.salary_ceiling.should  == 40000
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
    end
  end

end
