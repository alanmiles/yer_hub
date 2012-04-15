require 'spec_helper'

describe AbscatsController do

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
        @attr = { :category => "Sickness on full pay", :abbreviation => "SF",
                     :created_by => 1 }
      end

      it "should not create a new absence category" do
        lambda do
          post :create, :abscat => @attr
        end.should_not change(Abscat, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :abscat => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :abscat => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @user = Factory(:user)
      @abscat = Factory(:abscat, :created_by => @user.id)
    end
    
    describe "GET 'show'" do
    
      it "should not be successful" do
        get :show, :id => @abscat
        response.should_not be_success
      end
        
      it "should redirect to the signin page" do
        get :show, :id => @abscat
        response.should redirect_to signin_path
      end   
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @abscat
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @abscat
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :category => "Examination leave", :abbreviation => "EX",
                      :created_by => @user.id }
      end

      it "should not change the absence category's attributes" do
        put :update, :id => @abscat, :abscat => @attr
        @abscat.reload
        @abscat.category.should_not  == @attr[:category]
        @abscat.abbreviation.should_not == @attr[:abbreviation]
      end

      it "should redirect to the root path" do
        put :update, :id => @abscat, :abscat => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the absence category" do
        lambda do
          delete :destroy, :id => @abscat
        end.should_not change(Abscat, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @abscat
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
          @attr = { :category => "Sickness on full pay", :abbreviation => "SF",
                     :created_by => 1 }
        end
        
        it "should redirect to the home page" do
          post :create, :abscat => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :abscat => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @abscat = Factory(:abscat, :created_by => @user.id)
      end
      
      describe "GET 'show'" do  

        it "should not be successful" do
          get :show, :id => @abscat
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :show, :id => @abscat
          response.should redirect_to root_path
        end   
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @abscat
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @abscat
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :category => "Examination leave", :abbreviation => "EX",
                      :created_by => @user.id }
        end

        it "should not change the absence category's attributes" do
          put :update, :id => @abscat, :abscat => @attr
          @abscat.reload
          @abscat.category.should_not  == @attr[:category]
          @abscat.abbreviation.should_not == @attr[:abbreviation]
        end

        it "should redirect to the root path" do
          put :update, :id => @abscat, :abscat => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the absence category" do
          lambda do
            delete :destroy, :id => @abscat
          end.should_not change(Abscat, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @abscat
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @abscat
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
            @abscat = Factory(:abscat, :created_by => @admin.id, :approved => true)
            @abscat1 = Factory(:abscat, :category => "Sickness on zero pay", :abbreviation => "SZ",
          			:approved => true, :created_by => @admin.id)
            @abscats = [@abscat, @abscat1]
          end
        
          it "should be successful" do
            get :index
            response.should be_success
          end
    
          it "should have the right title" do
            get :index
            response.should have_selector("title", :content => "Absence types")
          end
        
          it "should have an element for each absence category" do
            get :index
            @abscats.each do |abscat|
              response.should have_selector("li", :content => abscat.category)
            end
          end
      
          it "should have a link to the 'edit' page for each absence category" do
            get :index
            @abscats.each do |abscat|
              response.should have_selector("a", :href => edit_abscat_path(abscat))
            end        
          end
        
          it "should not have an 'Approval' marker if approval has been given" do
            get :index
            @abscats.each do |abscat|
              response.should_not have_selector("li", :content => "Approval?")
            end
          end
        
          it "should have a return button to the admin menu" do
            get :index
            response.should have_selector("a", :href => admin_home_path)
          end
        
          it "should have a link to the 'new' page" do
            get :index
            response.should have_selector("a", :href => new_abscat_path)
          end       
        
        end
        
        describe "where approvals are required" do
        
          before(:each) do
            @abscat = Factory(:abscat, :created_by => @admin.id, :approved => false)
            @abscat1 = Factory(:abscat, :category => "Sickness on zero pay", :abbreviation => "SZ",
          			:approved => false, :created_by => @admin.id)
            @abscats = [@abscat, @abscat1]
          end
          
          it "should show where approvals are required - and give a link to the edit page" do
            get :index
            @abscats.each do |abscat|
              response.should have_selector("a", :href => edit_abscat_path(abscat),
              					:content => "Approval?")
            end
          end
        
          it "should include a delete link if the absence category has never been used"
        
        end 
        
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new
          response.should be_success
        end
    
        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New absence type")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :category => "", :abbreviation => "",
                  :created_by => nil }
          end

          it "should not create an absence category" do
            lambda do
              post :create, :abscat => @attr
            end.should_not change(Abscat, :count)
          end

          it "should have the right title" do
            post :create, :abscat => @attr
            response.should have_selector("title", :content => "New absence type")
          end

          it "should render the 'new' page" do
            post :create, :abscat => @attr
            response.should render_template('new')
          end
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :category => "Sickness on full pay", :abbreviation => "SF",
                     :created_by => 1 }
        end

        it "should create an absence category" do
          lambda do
            post :create, :abscat => @attr
          end.should change(Abscat, :count).by(1)
        end
      
        it "should redirect to the absence category show page" do
          post :create, :abscat => @attr
          response.should redirect_to(abscat_path(assigns(:abscat)))
        end
      
        it "should have a success message" do
          post :create, :abscat => @attr
          flash[:success].should =~ /added a new absence type/i
        end    
      end    
    
      describe "GET 'show'" do
    
        before(:each) do
          @abscat = Factory(:abscat, :created_by => @admin.id)
        end

        it "should be successful" do
          get :show, :id => @abscat
          response.should be_success
        end

        it "should find the right currency" do
          get :show, :id => @abscat
          assigns(:abscat).should == @abscat
        end
    
        it "should have the right title" do
          get :show, :id => @abscat
          response.should have_selector("title", :content => "Absence type")
        end
        
        it "should have a link to the absence category's edit page" do
          get :show, :id => @abscat
          response.should have_selector("a", :href => edit_abscat_path(@abscat))
        end
        
        it "should have a link to the absence category list" do
          get :show, :id => @abscat
          response.should have_selector("a", :href => abscats_path)
        end
      end
      
      describe "GET 'edit'" do

        before(:each) do
          @abscat = Factory(:abscat, :created_by => @admin.id)
        end

        it "should be successful" do
          get :edit, :id => @abscat
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @abscat
          response.should have_selector("title", :content => "Edit absence type")
        end

        it "should permit changes to the absence category name" do
          get :edit, :id => @abscat
          response.should have_selector("input", :name => "abscat[category]")
        end

        it "should permit changes to the abbreviation" do
          get :edit, :id => @abscat
          response.should have_selector("input", :name => "abscat[abbreviation]")
        end
        
        it "should have approval checkboxes" do
          get :edit, :id => @abscat
          response.should have_selector("input", :name => "abscat[approved]")
        end
        
        it "should not permit changes to 'created_by'" do
          get :edit, :id => @abscat
          response.should have_selector("input", :name => "abscat[created_by]",
                                                 :type => "hidden")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @abscat
          response.should have_selector("input", :type => "submit", :value => "Update Absence Type")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @abscat = Factory(:abscat, :created_by => @admin.id)
        end

        describe "failure" do

          before(:each) do
            @attr = { :category => "", :abbreviation => "",
                  :created_by => nil }
          end

          it "should render the 'edit' page" do
            put :update, :id => @abscat, :abscat => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @abscat, :abscat => @attr
            response.should have_selector("title", :content => "Edit absence type")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :category => "Marriage", :abbreviation => "MG",
                      :created_by => @admin.id }
          end

          it "should change the absence category's attributes" do
            put :update, :id => @abscat, :abscat => @attr
            @abscat.reload
            @abscat.category.should  == @attr[:category]
            @abscat.abbreviation.should == @attr[:abbreviation]
          end

          it "should redirect to the absence category show page" do
            put :update, :id => @abscat, :abscat => @attr
            response.should redirect_to(abscat_path(@abscat))
          end

          it "should have a flash message" do
            put :update, :id => @abscat, :abscat => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @abscat = Factory(:abscat, :created_by => @admin.id)
        end
      
        describe "if absence category has been used" do
        
          it "should protect the absence category"
          
          it "should redirect to the absence category list"
          
          it "should explain why the deletion could not be made"
          
        end
        
        describe "if absence category is unconnected and unused" do
        
          it "should destroy the absence category" do
            lambda do
              delete :destroy, :id => @abscat
            end.should change(Abscat, :count).by(-1)
          end
                   
          it "should confirm the deletion" do
            delete :destroy, :id => @abscat
            flash[:success].should =~ /successfully removed/i
          end
          
          it "should redirect to the absence category list" do
            delete :destroy, :id => @abscat
            response.should redirect_to abscats_path
          end
        end      
      end
    end
  end
end
