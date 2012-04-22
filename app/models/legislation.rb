# == Schema Information
#
# Table name: legislations
#
#  id                   :integer         not null, primary key
#  country_id           :integer
#  retirement_men       :integer         default(65)
#  retirement_women     :integer         default(60)
#  sickness_accruals    :boolean         default(FALSE)
#  max_sickness_accrual :integer         default(0)
#  probation_days       :integer         default(90)
#  created_at           :datetime
#  updated_at           :datetime
#

class Legislation < ActiveRecord::Base

  attr_accessible  :country_id, :retirement_men, :retirement_women, :sickness_accruals, :max_sickness_accrual, :probation_days
  
  belongs_to :country
  
  validates	:country_id,		:presence		=> true,
  					:uniqueness		=> true
  validates	:retirement_men,	:presence 		=> true,
  					:numericality		=> { :only_integer => true },
  					:inclusion		=> { :in => 40..80 }
  validates	:retirement_women,	:presence 		=> true,
  					:numericality		=> { :only_integer => true },
  					:inclusion		=> { :in => 40..80 } 					
  validates	:max_sickness_accrual, 	:presence 		=> true,					
  					:numericality		=> { :only_integer => true }
  validates	:probation_days, 	:presence 		=> true,					
  					:numericality		=> { :only_integer => true }
  										
end
