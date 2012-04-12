# == Schema Information
#
# Table name: currencies
#
#  id                :integer         not null, primary key
#  currency          :string(255)
#  abbreviation      :string(255)
#  dec_places        :integer
#  change_to_dollars :decimal(8, 5)
#  approved          :boolean         default(FALSE)
#  created_by        :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Currency < ActiveRecord::Base

  attr_accessible :currency, :abbreviation, :dec_places, :change_to_dollars, :approved, :created_by
  
  has_many :countries
  
  validates :currency,		:presence 	=> true,
  				:length		=> { :maximum => 50 },
  				:uniqueness 	=> { :case_sensitive => false }
  validates :abbreviation,	:presence 	=> true,
  				:length		=> { :maximum => 3 },
  				:uniqueness 	=> { :case_sensitive => false }
  validates :dec_places,	:presence 	=> true,
  				:numericality 	=> { :only_integer => true }			
  validates :created_by,	:presence 	=> true
  validates :change_to_dollars,	:numericality 	=> true, :allow_nil => true
end
