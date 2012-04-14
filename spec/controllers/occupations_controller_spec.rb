require 'spec_helper'

describe OccupationsController do

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
        @attr = { :occupation => "Security", :created_by => 1 }
      end

      it "should not create a new occupation" do
        lambda do
          post :create, :occupation => @attr
        end.should_not change(Occupation, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :occupation => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :occupation => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @user = Factory(:user)
      @occupation = Factory(:occupation, :created_by => @user.id)
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @occupation
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @occupation
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :occupation => "Secretary", :created_by => @user.id }
      end

      it "should not change the occupation's attributes" do
        put :update, :id => @occupation, :occupation => @attr
        @occupation.reload
        @occupation.occupation.should_not  == @attr[:occupation]
      end

      it "should redirect to the root path" do
        put :update, :id => @occupation, :occupation => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the occupation" do
        lambda do
          delete :destroy, :id => @occupation
        end.should_not change(Occupation, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @occupation
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
          @attr = { :occupation => "Security", :created_by => 1 }
        end
        
        it "should redirect to the home page" do
          post :create, :occupation => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :occupation => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @occupation = Factory(:occupation, :created_by => @user.id)
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @occupation
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @occupation
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :occupation => "Welder", :created_by => @user.id }
        end

        it "should not change the occupation's attributes" do
          put :update, :id => @occupation, :occupation => @attr
          @occupation.reload
          @occupation.occupation.should_not  == @attr[:occupation]
        end

        it "should redirect to the root path" do
          put :update, :id => @occupation, :occupation => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the occupation" do
          lambda do
            delete :destroy, :id => @occupation
          end.should_not change(Occupation, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @occupation
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @occupation
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
            @occupation = Factory(:occupation, :created_by => @admin.id, :approved => true)
            @occupation1 = Factory(:occupation, :occupation => "Miner", :approved => true, :created_by => @admin.id)
            @occupations = [@occupation, @occupation1]
          end
        
          it "should be successful" do
            get :index
            response.should be_success
          end
    
          it "should have the right title" do
            get :index
            response.should have_selector("title", :content => "Occupations")
          end
        
          it "should have an element for each occupation" do
            get :index
            @occupations.each do |occupation|
              response.should have_selector("li", :content => occupation.occupation)
            end
          end
      
          it "should have a link to the 'edit' page for each occupation" do
            get :index
            @occupations.each do |occupation|
              response.should have_selector("a", :href => edit_occupation_path(occupation))
            end        
          end
        
          it "should not have an 'Approval' marker if approval has been given" do
            get :index
            @occupations.each do |occupation|
              response.should_not have_selector("li", :content => "Approval?")
            end
          end
        
          it "should have a return button to the admin menu" do
            get :index
            response.should have_selector("a", :href => admin_home_path)
          end
        
          it "should have a link to the 'new' page" do
            get :index
            response.should have_selector("a", :href => new_occupation_path)
          end       
        
        end
        
        describe "where approvals are required" do
        
          before(:each) do
            @occupation = Factory(:occupation, :created_by => @admin.id, :approved => false)
            @occupation1 = Factory(:occupation, :occupation => "Miner", :approved => false, :created_by => @admin.id)
            @occupations = [@occupation, @occupation1]
          end
          
          it "should show where approvals are required - and give a link to the edit page" do
            get :index
            @occupations.each do |occupation|
              response.should have_selector("a", :href => edit_occupation_path(occupation),
              					:content => "Approval?")
            end
          end
        
          it "should include a delete link if the sector is not linked to a job"
        
        end 
        
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new
          response.should be_success
        end
    
        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New occupation")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :occupation => "", :created_by => nil }
          end

          it "should not create an occupation" do
            lambda do
              post :create, :occupation => @attr
            end.should_not change(Occupation, :count)
          end

          it "should have the right title" do
            post :create, :occupation => @attr
            response.should have_selector("title", :content => "New occupation")
          end

          it "should render the 'new' page" do
            post :create, :occupation => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :occupation => "Nurse", :created_by => @admin.id }
        end

        it "should create an occupation" do
          lambda do
            post :create, :occupation => @attr
          end.should change(Occupation, :count).by(1)
        end
      
        it "should redirect to the occupation list page" do
          post :create, :occupation => @attr
          response.should redirect_to occupations_path
        end
      
        it "should have a success message" do
          post :create, :occupation => @attr
          flash[:success].should =~ /successfully added/i
        end    
      end    
    
      
      describe "GET 'edit'" do

        before(:each) do
          @occupation = Factory(:occupation, :created_by => @admin.id)
        end

        it "should be successful" do
          get :edit, :id => @occupation
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @occupation
          response.should have_selector("title", :content => "Edit occupation")
        end

        it "should permit changes to the occupation name" do
          get :edit, :id => @occupation
          response.should have_selector("input", :name => "occupation[occupation]")
        end
        
        it "should have approval checkboxes" do
          get :edit, :id => @occupation
          response.should have_selector("input", :name => "occupation[approved]")
        end
        
        it "should not permit changes to 'created_by'" do
          get :edit, :id => @occupation
          response.should have_selector("input", :name => "occupation[created_by]",
                                                 :type => "hidden")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @occupation
          response.should have_selector("input", :type => "submit", :value => "Update Occupation")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @occupation = Factory(:occupation, :created_by => @admin.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :occupation => "", :created_by => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @occupation, :occupation => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @occupation, :occupation => @attr
            response.should have_selector("title", :content => "Edit occupation")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :occupation => "Doctor", :created_by => @admin.id }
          end

          it "should change the occupation's attributes" do
            put :update, :id => @occupation, :occupation => @attr
            @occupation.reload
            @occupation.occupation.should  == @attr[:occupation]
          end

          it "should redirect to the occupation list page" do
            put :update, :id => @occupation, :occupation => @attr
            response.should redirect_to occupations_path
          end

          it "should have a flash message" do
            put :update, :id => @occupation, :occupation => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @occupation = Factory(:occupation, :created_by => @admin.id)
        end
      
        describe "if occupation is connected to a job" do
        
          it "should protect the occupation"
          
          it "should redirect to the occupation list"
          
          it "should explain why the deletion could not be made"
          
        end
        
        describe "if occupation is unconnected" do
        
          it "should destroy the occupation" do
            lambda do
              delete :destroy, :id => @occupation
            end.should change(Occupation, :count).by(-1)
          end
                   
          it "should confirm the deletion" do
            delete :destroy, :id => @occupation
            flash[:success].should =~ /successfully removed/i
          end
          
          it "should redirect to the occupation list" do
            delete :destroy, :id => @occupation
            response.should redirect_to occupations_path
          end
        end      
      end
    end
  end
end
