# == Schema Information
#
# Table name: notes
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Note do
  
  before(:each) do
    @attr =   { :title => "First note", 
    		:content => "This is just the first note." }
  end

  it "should create a new instance given valid attributes" do
    Note.create!(@attr)
  end

  it "should require a title" do
    no_title_note = Note.new(@attr.merge(:title => ""))
    no_title_note.should_not be_valid
  end
  
  it "should require content" do
    no_content_note = Note.new(@attr.merge(:content => ""))
    no_content_note.should_not be_valid
  end
  
  it "should reject titles that are too long" do
    long_title = "a" * 51
    long_title_note = Note.new(@attr.merge(:title => long_title))
    long_title_note.should_not be_valid
  end
  
  it "should reject duplicate titles" do
    Note.create!(@attr)
    note_with_duplicate_title = Note.new(@attr)
    note_with_duplicate_title.should_not be_valid
  end
  
  it "should reject duplicate titles identical up to case" do
    upcased_title = @attr[:title].upcase
    Note.create!(@attr.merge(:title => upcased_title))
    note_with_duplicate_title = Note.new(@attr)
    note_with_duplicate_title.should_not be_valid
  end
end
