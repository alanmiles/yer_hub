class NotesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy, :show]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user, :except => :show
  
  def index
    @title = "Guidance notes"
    @notes = Note.order("title").paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @title = "Note"
    if params[:id] == "0"
      @content_header = "Guidance notes"
      @content_detail = "Sorry, there's no additional help for this page."
    else
      @note = Note.find(params[:id])
      @content_header = "Notes for '#{@note.title}'"
      @content_detail = @note.content
    end
  end
  
  def new
    @title = "New note"
    @note = Note.new
  end
  
  def create
    @note = Note.new(params[:note])
    if @note.save
      flash[:success] = "The note has been successfully added to the list"
      redirect_to @note
    else
      @title = "New note"
      render 'new'
    end
  end
  
  def edit
    @note = Note.find(params[:id])
    @title = "Edit note"
  end
  
  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:success] = "Note updated."
      redirect_to @note
    else
      @title = "Edit note"
      render 'edit'
    end
  end
  
  def destroy
    @note = Note.find(params[:id]).destroy
    flash[:success] = "Note for '#{@note.title}' removed."
    redirect_to notes_path
  end


end
