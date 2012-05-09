require 'spec_helper'

describe EnterprisesController do

  render_views

  before(:each) do
    @user = Factory(:user)
    @sector = Factory(:sector)
    @currency = Factory(:currency)
    @nationality = Factory(:nationality)
    @country = Factory(:country, :nationality_id => @nationality.id, :currency_id => @currency.id)
    @abscat = Factory(:abscat, :approved => true) 
  end
  
  describe "not signed in" do
  
    describe "GET 'new'" do
      
      it "should be successful" do
        get :new
        response.should_not be_success
      end
    
      it "should redirect to the home page" do
        get :new
        response.should redirect_to signin_path
      end
      
      it "should have an explanatory message" do
        get :new
        flash[:notice].should =~ /please sign in/i
      end
    
    end
    
  end
  
  describe "signed in" do 
 
    before(:each) do
      @user = test_sign_in(Factory(:user, :email => "etest@example.com"))
    end
 
    describe "GET 'new'" do
      
      it "should be successful" do
        get :new
        response.should be_success
      end
    
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "New enterprise")    
      end
    
      it "should have an entry-box for the enterprise name" do
        get :new
        response.should have_selector("input", :name => "enterprise[name]")
      end
    
      it "should have an entry-box for the enterprise short name" do
        get :new
        response.should have_selector("input", :name => "enterprise[short_name]")
      end
    
      it "should have an entry-box for the company registration" do
        get :new
        response.should have_selector("input", :name => "enterprise[company_registration]")
      end
    
      it "should have address line entry-boxes" do
        get :new
        response.should have_selector("input", :name => "enterprise[address_1]")
        response.should have_selector("input", :name => "enterprise[address_2]")
        response.should have_selector("input", :name => "enterprise[address_3]")
      end
    
      it "should have a town entry-box" do
        get :new
        response.should have_selector("input", :name => "enterprise[town]")
      end
    
      it "should have a state entry-box" do
        get :new
        response.should have_selector("input", :name => "enterprise[district]")
      end
    
      it "should have a zip-code entry-box" do
        get :new
        response.should have_selector("input", :name => "enterprise[zipcode]")
      end
    
      it "should allow a country selection" do
        get :new
        response.should have_selector("select", :name => "enterprise[country_id]")
      end
    
      it "should have a home airport entry-box" do
        get :new
        response.should have_selector("input", :name => "enterprise[home_airport]")
      end
    
      it "should allow a sector selection" do
        get :new
        response.should have_selector("select", :name => "enterprise[sector_id]")
      end
    
      it "should have a 'terms accepted' check-box" do
        get :new
        response.should have_selector("input", :type => "checkbox", :name => "enterprise[terms_accepted]")
      end
      
      it "should have a hidden user_id field" do
        get :new
        response.should have_selector("input", :type => "hidden", :value => @user.id.to_s)
      end
      
      it "should have a create button" do
        get :new
        response.should have_selector("input", :type => "submit", :value => "Create Enterprise")
      end
    
      it "should allow you to log in as an employee instead" do
        get :new
        response.should have_selector("a", :content => "click here")
      end
    end
  
    describe "GET 'create'" do
  
      describe "failure" do
      
        before(:each) do
          @attr = { :name => "", :short_name => "",
                  :country_id => nil, :sector_id => nil }
        end

        it "should not create an enterprise" do
          lambda do
            post :create, :enterprise => @attr
          end.should_not change(Enterprise, :count)
        end

        it "should have the right title" do
          post :create, :enterprise => @attr
          response.should have_selector("title", :content => "New enterprise")
        end

        it "should render the 'new' page" do
          post :create, :enterprise => @attr
          response.should render_template('new')
        end
      end
    
      describe "success" do

        before(:each) do
    
          @attr = { :name => "New Enterprise Co", :short_name => "NewCo",
                  :country_id => @country.id, :sector_id => @sector.id, :created_by => @user.id }
        end

        it "should create an Enterprise" do
          lambda do
            post :create, :enterprise => @attr
          end.should change(Enterprise, :count).by(1)
        end
       
        it "should correctly assign the current user to 'created_by'" do
          post :create, :enterprise => @attr
          @enterprise = Enterprise.last
          @enterprise.created_by.should == @user.id
        end
        
        #creation of associated tables tested in model
      
        it "should redirect to the enterprise show page" do
          post :create, :enterprise => @attr
          response.should redirect_to enterprise_path(assigns(:enterprise))
        end
      
        it "should have a success message" do
          post :create, :enterprise => @attr
          flash[:success].should =~ /added/i
        end    
      end   
    end
  end
end
