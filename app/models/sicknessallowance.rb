# == Schema Information
#
# Table name: sicknessallowances
#
#  id             :integer         not null, primary key
#  country_id     :integer
#  sick_days_from :integer
#  sick_days_to   :integer
#  deduction_rate :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Sicknessallowance < ActiveRecord::Base

  attr_accessible :country_id, :sick_days_from, :sick_days_to, :deduction_rate
  
  belongs_to :country
  
  validates	:country_id,		:presence 		=> true
  validates	:sick_days_from,	:presence 		=> true,
  					:uniqueness		=> { :scope => :country_id }, 
  					:numericality		=> { :only_integer => true, :allow_zero => true },
  					:inclusion		=> { :in => 0..365 }
  validates	:sick_days_to,		:presence 		=> true,
  					:uniqueness		=> { :scope => :country_id }, 
  					:numericality		=> { :only_integer => true },
  					:inclusion		=> { :in => 1..365 }
  validates	:deduction_rate,	:presence		=> true,
  					:numericality		=> { :only_integer => true, :allow_zero => true },
  					:inclusion		=> { :in => 0..100 }
  
end
