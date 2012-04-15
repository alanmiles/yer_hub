# == Schema Information
#
# Table name: abscats
#
#  id           :integer         not null, primary key
#  category     :string(255)
#  abbreviation :string(255)
#  approved     :boolean         default(FALSE)
#  created_by   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Abscat < ActiveRecord::Base

  attr_accessible :category, :abbreviation, :approved, :created_by
  
  validates :category,		:presence 	=> true,
  				:length		=> { :maximum => 50 },
  				:uniqueness 	=> { :case_sensitive => false }
  validates :abbreviation,	:presence 	=> true,
  				:length		=> { :is => 2 },
  				:uniqueness 	=> { :case_sensitive => false }
  validates :created_by,	:presence 	=> true
 
end
