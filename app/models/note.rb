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

class Note < ActiveRecord::Base

  attr_accessible :title, :content
  
  validates	:title,  	:presence 		=> true,
                                :uniqueness		=> { :case_sensitive => false },
                                :length			=> { :maximum => 50 }
  validates	:content,	:presence		=> true
  
end
