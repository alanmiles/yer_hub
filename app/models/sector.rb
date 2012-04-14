# == Schema Information
#
# Table name: sectors
#
#  id         :integer         not null, primary key
#  sector     :string(255)
#  approved   :boolean
#  created_by :integer
#  created_at :datetime
#  updated_at :datetime
#

class Sector < ActiveRecord::Base

  attr_accessible :sector, :approved, :created_by
  
  validates :sector,		:presence 	=> true,
  				:length		=> { :maximum => 50 },
  				:uniqueness 	=> { :case_sensitive => false }
  					
  validates :created_by,	:presence 	=> true,
 				:numericality 	=> { :only_integer => true }	
end
