require 'spec_helper'

describe NationalitiesController do

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
        @attr = { :nationality => "Japanese", :abbreviation => "BHD" }
      end

      it "should not create a new nationality" do
        lambda do
          post :create, :nationality => @attr
        end.should_not change(Nationality, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :nationality => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :nationality => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @nationality = Factory(:nationality)
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @nationality
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @nationality
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :nationality => "Burmese" }
      end

      it "should not change the nationality's attributes" do
        put :update, :id => @nationality, :nationality => @attr
        @nationality.reload
        @nationality.nationality.should_not  == @attr[:nationality]
      end

      it "should redirect to the root path" do
        put :update, :id => @nationality, :nationality => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the nationality" do
        lambda do
          delete :destroy, :id => @nationality
        end.should_not change(Nationality, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @nationality
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
          @attr = { :nationality => "Indian" }
        end
        
        it "should redirect to the home page" do
          post :create, :nationality => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :nationality => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @nationality = Factory(:nationality)
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @nationality
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @nationality
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :nationality => "Pakistani" }
        end

        it "should not change the nationality's attributes" do
          put :update, :id => @nationality, :nationality => @attr
          @nationality.reload
          @nationality.nationality.should_not  == @attr[:nationality]
        end

        it "should redirect to the root path" do
          put :update, :id => @nationality, :nationality => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the nationality" do
          lambda do
            delete :destroy, :id => @nationality
          end.should_not change(Nationality, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @nationality
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @nationality
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
          @nationality1 = Factory(:nationality, :nationality => "Australian")
          @nationalities = [@nationality, @nationality1]
        end
        
        it "should be successful" do
          get :index
          response.should be_success
        end
    
        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "Nationalities")
        end
        
        it "should have an element for each nationality" do
          get :index
          @nationalities.each do |nationality|
            response.should have_selector("li", :content => nationality.nationality)
          end
        end
      
        it "should have a link to the 'edit' page for each nationality" do
          get :index
          @nationalities.each do |nationality|
            response.should have_selector("a", :href => edit_nationality_path(nationality))
          end        
        end
        
        it "should have a return button to the admin menu" do
          get :index
          response.should have_selector("a", :href => admin_home_path)
        end
        
        it "should have a link to the 'new' page" do
          get :index
          response.should have_selector("a", :href => new_nationality_path)
        end       
        
        it "should include a delete link if the nationality is not linked to a country" do
          get :index
          @nationalities.each do |nationality|
            response.should have_selector("a", :href => nationality_path(nationality),
            				:title => "Delete #{nationality.nationality}")
          end
        end 
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new
          response.should be_success
        end
    
        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New nationality")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :nationality => "" }
          end

          it "should not create a nationality" do
            lambda do
              post :create, :nationality => @attr
            end.should_not change(Nationality, :count)
          end

          it "should have the right title" do
            post :create, :nationality => @attr
            response.should have_selector("title", :content => "New nationality")
          end

          it "should render the 'new' page" do
            post :create, :nationality => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :nationality => "German" }
        end

        it "should create a nationality" do
          lambda do
            post :create, :nationality => @attr
          end.should change(Nationality, :count).by(1)
        end
      
        it "should redirect to the nationality index page" do
          post :create, :nationality => @attr
          response.should redirect_to nationalities_path
        end
      
        it "should have a success message" do
          post :create, :nationality => @attr
          flash[:success].should =~ /successfully added/i
        end    
      end    
      
      describe "GET 'edit'" do

        before(:each) do
          @nationality = Factory(:nationality)
        end

        it "should be successful" do
          get :edit, :id => @nationality
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @nationality
          response.should have_selector("title", :content => "Edit nationality")
        end

        it "should permit changes to the nationality name" do
          get :edit, :id => @nationality
          response.should have_selector("input", :name => "nationality[nationality]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @nationality
          response.should have_selector("input", :type => "submit", :value => "Update Nationality")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @nationality = Factory(:nationality)
        end

        describe "failure" do

          before(:each) do
            @attr = { :nationality => "" }
          end

          it "should render the 'edit' page" do
            put :update, :id => @nationality, :nationality => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @nationality, :nationality => @attr
            response.should have_selector("title", :content => "Edit nationality")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :nationality => "Nigerian" }
          end

          it "should change the nationality's attributes" do
            put :update, :id => @nationality, :nationality => @attr
            @nationality.reload
            @nationality.nationality.should  == @attr[:nationality]
          end

          it "should redirect to the nationality index page" do
            put :update, :id => @nationality, :nationality => @attr
            response.should redirect_to nationalities_path
          end

          it "should have a flash message" do
            put :update, :id => @nationality, :nationality => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @nationality = Factory(:nationality)
        end
      
        describe "if nationality is connected to a country" do
        
          it "should protect the nationality"
          
          it "should redirect to the nationality list"
          
          it "should explain why the deletion could not be made"
          
        end
        
        describe "if nationality is unconnected" do
        
          it "should destroy the nationality" do
            lambda do
              delete :destroy, :id => @nationality
            end.should change(Nationality, :count).by(-1)
          end
                   
          it "should confirm the deletion" do
            delete :destroy, :id => @nationality
            flash[:success].should =~ /successfully removed/i
          end
          
          it "should redirect to the nationality list" do
            delete :destroy, :id => @nationality
            response.should redirect_to nationalities_path
          end
        end      
      end
    end
  end
end
