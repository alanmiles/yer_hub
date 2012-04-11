module ApplicationHelper

  def logo
    image_tag("hygwit.png", :alt => "Yer Hub")
  end
  
  def title
    base_title = "Yer Hub"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def note_reference
    ref = 0
    unless @title.nil?
      @nt = Note.find_by_title(@title)
      unless @nt.nil?
        ref = @nt.id
      end
    end
    return ref
  end
  
  def note_title
    if note_reference == 0
      @content_header = "Guidance notes"
    else
      @result = Note.find(note_reference)
      @content_header = "Notes for '#{@result.title}'"
    end
  end
  
  def note_content
    if note_reference == 0
      @content_detail = "Sorry, there's no additional help for this page."
    else
      @result = Note.find(note_reference)
      @content_detail = simple_format(@result.content)
    end
  end
  
end
