# == Schema Information
#
# Table name: occupations
#
#  id         :integer         not null, primary key
#  occupation :string(255)
#  approved   :boolean         default(FALSE)
#  created_by :integer
#  created_at :datetime
#  updated_at :datetime
#

class Occupation < ActiveRecord::Base

  attr_accessible :occupation, :approved, :created_by

  validates :occupation,	:presence 	=> true,
  				:length		=> { :maximum => 50 },
  				:uniqueness 	=> { :case_sensitive => false }
  					
  validates :created_by,	:presence 	=> true,
 				:numericality 	=> { :only_integer => true }	
end
