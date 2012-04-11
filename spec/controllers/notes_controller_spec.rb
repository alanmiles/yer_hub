require 'spec_helper'

describe NotesController do

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
        @attr = { :title => "Note One", :content => "This is the first note." }
      end

      it "should not create a new note" do
        lambda do
          post :create, :note => @attr
        end.should_not change(Note, :count)
      end
    
      it "should redirect to the home page" do
        post :create, :note => @attr
        response.should redirect_to root_path
      end
      
      it "should issue a warning message" do
        post :create, :note => @attr
        flash[:warning].should =~ /not authorized/i
      end
    end
    
    before(:each) do
      @note = Factory(:note)
    end
    
    describe "GET 'show'" do
    
      it "should be successful" do
        get :show, :id => @note
        response.should be_success
      end
      
      it "should not have an edit link" do
        get :show, :id => @note
        response.should_not have_selector("a", :href => edit_note_path(@note))
      end
    end
    
    describe "GET 'edit'" do

      it "should not be successful" do
        get :edit, :id => @note
        response.should_not be_success
      end
        
      it "should redirect to the login page" do
        get :edit, :id => @note
        response.should redirect_to signin_path
      end
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @attr = { :title => "Another note", :content => "More note content" }
      end

      it "should not change the note's attributes" do
        put :update, :id => @note, :note => @attr
        @note.reload
        @note.title.should_not  == @attr[:title]
        @note.content.should_not == @attr[:content]
      end

      it "should redirect to the root path" do
        put :update, :id => @note, :currency => @attr
        response.should redirect_to root_path
      end
    end
    
    describe "DELETE 'destroy'" do
      
      it "should protect the note" do
        lambda do
          delete :destroy, :id => @note
        end.should_not change(Note, :count)
      end
                   
      it "should redirect to the home page path" do
        delete :destroy, :id => @note
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
          @attr = { :title => "Next title", :content => "This is the next note" }
        end
        
        it "should redirect to the home page" do
          post :create, :note => @attr
          response.should redirect_to root_path
        end
      
        it "should issue a warning message" do
          post :create, :note => @attr
          flash[:warning].should =~ /only available to administrators/i
        end
      
      end
      
      before(:each) do
        @note = Factory(:note)
      end
      
      describe "GET 'show'" do  

        it "should be successful" do
          get :show, :id => @note
          response.should be_success
        end
        
        it "should not have an edit link" do
          get :show, :id => @note
          response.should_not have_selector("a", :href => edit_note_path(@note))
        end
         
      end
      
      describe "GET 'edit'" do

        it "should not be successful" do
          get :edit, :id => @note
          response.should_not be_success
        end
        
        it "should redirect to the home page" do
          get :edit, :id => @note
          response.should redirect_to root_path
        end
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @attr = { :title => "New note", :content => "This is a new note." }
        end

        it "should not change the note's attributes" do
          put :update, :id => @note, :note => @attr
          @note.reload
          @note.title.should_not  == @attr[:title]
          @note.content.should_not == @attr[:content]
        end

        it "should redirect to the root path" do
          put :update, :id => @note, :note => @attr
          response.should redirect_to root_path
        end
      end
      
      describe "DELETE 'destroy'" do
      
        it "should protect the note" do
          lambda do
            delete :destroy, :id => @note
          end.should_not change(Note, :count)
        end
                   
        it "should redirect to the root path" do
          delete :destroy, :id => @note
          response.should redirect_to root_path
        end
        
        it "should have a warning message" do
          delete :destroy, :id => @note
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
          @note = Factory(:note, :title => "My first note", :content => "This is my first note")
          @note2 = Factory(:note, :title => "Adding a note", :content => "This is a note we're adding")
          @notes = [@note, @note2]
        end
        
        it "should be successful" do
          get :index
          response.should be_success
        end
    
        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "Guidance notes")
        end
        
        it "should have an element for each note" do
          get :index
          @notes.each do |note|
            response.should have_selector("li", :content => note.title)
          end
        end
      
        it "should have a link to the 'show' page for each note" do
          get :index
          @notes.each do |note|
            response.should have_selector("a", :href => note_path(note))
          end        
        end
        
        it "should have a return button to the admin menu" do
          get :index
          response.should have_selector("a", :href => admin_home_path)
        end
        
        it "should have a link to the 'new' page" do
          get :index
          response.should have_selector("a", :href => new_note_path)
        end       
      end
  
      describe "GET 'new'" do
        it "should be successful" do
          get :new
          response.should be_success
        end
    
        it "should have the right title" do
          get :new
          response.should have_selector("title", :content => "New note")
        end
      end
      
      describe "POST 'create'" do

        describe "failure" do

          before(:each) do
            @attr = { :title => "", :content => "" }
          end

          it "should not create a note" do
            lambda do
              post :create, :note => @attr
            end.should_not change(Note, :count)
          end

          it "should have the right title" do
            post :create, :note => @attr
            response.should have_selector("title", :content => "New note")
          end

          it "should render the 'new' page" do
            post :create, :note => @attr
            response.should render_template('new')
          end
        end
           
        describe "success" do

          before(:each) do
            @attr = { :title => "Successful note", :content => "This note is successfully added" }
          end

          it "should create a note" do
            lambda do
              post :create, :note => @attr
            end.should change(Note, :count).by(1)
          end
      
          it "should redirect to the note show page" do
            post :create, :note => @attr
            response.should redirect_to(note_path(assigns(:note)))
          end
      
          it "should have a success message" do
            post :create, :note => @attr
            flash[:success].should =~ /successfully added/i
          end    
        end    
      end
      
      describe "GET 'show'" do
    
        before(:each) do
          @note = Factory(:note)
        end

        it "should be successful" do
          get :show, :id => @note
          response.should be_success
        end

        it "should find the right note" do
          get :show, :id => @note
          assigns(:note).should == @note
        end
    
        it "should have the right title" do
          get :show, :id => @note
          response.should have_selector("title", :content => "Note")
        end
        
        it "should have a link to the note's edit page" do
          get :show, :id => @note
          response.should have_selector("a", :href => edit_note_path(@note))
        end
        
        it "should have a link to the notes list" do
          get :show, :id => @note
          response.should have_selector("a", :href => notes_path)
        end
      end
      
      describe "GET 'edit'" do

        before(:each) do
          @note = Factory(:note)
        end

        it "should be successful" do
          get :edit, :id => @note
          response.should be_success
        end

        it "should have the right title" do
          get :edit, :id => @note
          response.should have_selector("title", :content => "Edit note")
        end

        it "should permit changes to the note title" do
          get :edit, :id => @note
          response.should have_selector("input", :name => "note[title]")
        end

        it "should permit changes to the content" do
          get :edit, :id => @note
          response.should have_selector("textarea", :name => "note[content]")
        end
        
        it "should contain a 'Submit' button" do
          get :edit, :id => @note
          response.should have_selector("input", :type => "submit", :value => "Update Note")
        end        
      end
      
      describe "PUT 'update'" do

        before(:each) do
          @note = Factory(:note)
        end

        describe "failure" do

          before(:each) do
            @attr = { :title => "", :content => "" }
          end

          it "should render the 'edit' page" do
            put :update, :id => @note, :note => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @note, :note => @attr
            response.should have_selector("title", :content => "Edit note")
          end
        end

        describe "success" do

          before(:each) do
            @attr = { :title => "Important note", :content => "This note is important" }
          end

          it "should change the note's attributes" do
            put :update, :id => @note, :note => @attr
            @note.reload
            @note.title.should  == @attr[:title]
            @note.content.should == @attr[:content]
          end

          it "should redirect to the note show page" do
            put :update, :id => @note, :note => @attr
            response.should redirect_to(note_path(@note))
          end

          it "should have a flash message" do
            put :update, :id => @note, :note => @attr
            flash[:success].should =~ /updated/
          end
        end
      end
      
      describe "DELETE 'destroy'" do
      
        before(:each) do
          @note = Factory(:note)
        end
        
        it "should destroy the note" do
          lambda do
            delete :destroy, :id => @note
          end.should change(Note, :count).by(-1)
        end
                   
        it "should confirm the deletion" do
          delete :destroy, :id => @note
          flash[:success].should =~ /removed/i
        end
          
        it "should redirect to the notes index" do
          delete :destroy, :id => @note
          response.should redirect_to notes_path
        end      
      end
    end 
  end  
end
