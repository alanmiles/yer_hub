# == Schema Information
#
# Table name: nationalities
#
#  id          :integer         not null, primary key
#  nationality :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Nationality < ActiveRecord::Base

  attr_accessible :nationality
  
  has_many :countries
  
  validates	:nationality,		:presence 	=> true,
					:length	  	=> { :maximum => 30 },
  					:uniqueness 	=> { :case_sensitive => false } 
  
end
