require 'spec_helper'

describe SectorsController do

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
        @attr = { :sector => "Banking", :created_by => 1 }
      end

      it "should not create a new sector" do
        lambda do
          post :create, :sector => @attr
        end.should_not change(Sector, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :sector => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :sector => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @user = Factory(:user)
      @sector = Factory(:sector, :created_by => @user.id)
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @sector
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @sector
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :sector => "Catering", :created_by => @user.id }
      end

      it "should not change the sector's attributes" do
        put :update, :id => @sector, :sector => @attr
        @sector.reload
        @sector.sector.should_not  == @attr[:sector]
      end

      it "should redirect to the root path" do
        put :update, :id => @sector, :sector => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the sector" do
        lambda do
          delete :destroy, :id => @sector
        end.should_not change(Sector, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @sector
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
          @attr = { :sector => "Banking", :created_by => 1 }
        end
        
        it "should redirect to the home page" do
          post :create, :sector => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :sector => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @sector = Factory(:sector, :created_by => @user.id)
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @sector
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @sector
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :sector => "Manufacture", :created_by => @user.id }
        end

        it "should not change the sector's attributes" do
          put :update, :id => @sector, :sector => @attr
          @sector.reload
          @sector.sector.should_not  == @attr[:sector]
        end

        it "should redirect to the root path" do
          put :update, :id => @sector, :sector => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the sector" do
          lambda do
            delete :destroy, :id => @sector
          end.should_not change(Sector, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @sector
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @sector
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
            @sector = Factory(:sector, :created_by => @admin.id, :approved => true)
            @sector1 = Factory(:sector, :sector => "Transportation", :approved => true, :created_by => @admin.id)
            @sectors = [@sector, @sector1]
          end
        
          it "should be successful" do
            get :index
            response.should be_success
          end
    
          it "should have the right title" do
            get :index
            response.should have_selector("title", :content => "Sectors")
          end
        
          it "should have an element for each sector" do
            get :index
            @sectors.each do |sector|
              response.should have_selector("li", :content => sector.sector)
            end
          end
      
          it "should have a link to the 'edit' page for each sector" do
            get :index
            @sectors.each do |sector|
              response.should have_selector("a", :href => edit_sector_path(sector))
            end        
          end
        
          it "should not have an 'Approval' marker if approval has been given" do
            get :index
            @sectors.each do |sector|
              response.should_not have_selector("li", :content => "Approval?")
            end
          end
        
          it "should have a return button to the admin menu" do
            get :index
            response.should have_selector("a", :href => admin_home_path)
          end
        
          it "should have a link to the 'new' page" do
            get :index
            response.should have_selector("a", :href => new_sector_path)
          end       
        
        end
        
        describe "where approvals are required" do
        
          before(:each) do
            @sector = Factory(:sector, :created_by => @admin.id, :approved => false)
            @sector1 = Factory(:sector, :sector => "Consultancy", :approved => false, :created_by => @admin.id)
            @sectors = [@sector, @sector1]
          end
          
          it "should show where approvals are required - and give a link to the edit page" do
            get :index
            @sectors.each do |sector|
              response.should have_selector("a", :href => edit_sector_path(sector),
              					:content => "Approval?")
            end
          end
        
          it "should include a delete link if the sector is not linked to a business"
        
        end 
        
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new
          response.should be_success
        end
    
        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New sector")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :sector => "", :created_by => nil }
          end

          it "should not create a sector" do
            lambda do
              post :create, :sector => @attr
            end.should_not change(Sector, :count)
          end

          it "should have the right title" do
            post :create, :sector => @attr
            response.should have_selector("title", :content => "New sector")
          end

          it "should render the 'new' page" do
            post :create, :sector => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :sector => "Hospitality", :created_by => @admin.id }
        end

        it "should create a sector" do
          lambda do
            post :create, :sector => @attr
          end.should change(Sector, :count).by(1)
        end
      
        it "should redirect to the sector list page" do
          post :create, :sector => @attr
          response.should redirect_to sectors_path
        end
      
        it "should have a success message" do
          post :create, :sector => @attr
          flash[:success].should =~ /successfully added/i
        end    
      end    
    
      
      describe "GET 'edit'" do

        before(:each) do
          @sector = Factory(:sector, :created_by => @admin.id)
        end

        it "should be successful" do
          get :edit, :id => @sector
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @sector
          response.should have_selector("title", :content => "Edit sector")
        end

        it "should permit changes to the sector name" do
          get :edit, :id => @sector
          response.should have_selector("input", :name => "sector[sector]")
        end
        
        it "should have approval checkboxes" do
          get :edit, :id => @sector
          response.should have_selector("input", :name => "sector[approved]")
        end
        
        it "should not permit changes to 'created_by'" do
          get :edit, :id => @sector
          response.should have_selector("input", :name => "sector[created_by]",
                                                 :type => "hidden")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @sector
          response.should have_selector("input", :type => "submit", :value => "Update Sector")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @sector = Factory(:sector, :created_by => @admin.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :sector => "", :created_by => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @sector, :sector => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @sector, :sector => @attr
            response.should have_selector("title", :content => "Edit sector")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :sector => "Warehousing", :created_by => @admin.id }
          end

          it "should change the sector's attributes" do
            put :update, :id => @sector, :sector => @attr
            @sector.reload
            @sector.sector.should  == @attr[:sector]
          end

          it "should redirect to the sector list page" do
            put :update, :id => @sector, :sector => @attr
            response.should redirect_to sectors_path
          end

          it "should have a flash message" do
            put :update, :id => @sector, :sector => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @sector = Factory(:sector, :created_by => @admin.id)
        end
      
        describe "if currency is connected to a business" do
        
          it "should protect the sector"
          
          it "should redirect to the sector list"
          
          it "should explain why the deletion could not be made"
          
        end
        
        describe "if sector is unconnected" do
        
          it "should destroy the sector" do
            lambda do
              delete :destroy, :id => @sector
            end.should change(Sector, :count).by(-1)
          end
                   
          it "should confirm the deletion" do
            delete :destroy, :id => @sector
            flash[:success].should =~ /successfully removed/i
          end
          
          it "should redirect to the sector list" do
            delete :destroy, :id => @sector
            response.should redirect_to sectors_path
          end
        end      
      end
    end
  end

end
