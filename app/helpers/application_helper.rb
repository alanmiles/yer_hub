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
  
end
