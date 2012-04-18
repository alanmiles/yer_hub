# == Schema Information
#
# Table name: insurancerules
#
#  id               :integer         not null, primary key
#  country_id       :integer					country to which rule applies
#  salary_ceiling   :integer         default(1000000)           monthly salary above which insurance doesn't apply - indemnity accrued instead
#                                                               default of 1 million means effectively no ceiling
#  startend_prorate :boolean         default(TRUE)              how are insurance deductions applied when employee starts or leaves?
#								y- default means that he pays for number of days in month - pro-rated
#								- false means that he pays full monthly amount if he joins before startend_date or leaves after
#  startend_date    :integer         default(15)                comes into play only if startend_prorate is false - the day of the month used to see
#								whether or not he should pay after joining or leaving.
#  created_at       :datetime
#  updated_at       :datetime
#

class Insurancerule < ActiveRecord::Base

  attr_accessible  :country_id, :salary_ceiling, :startend_prorate, :startend_date

  belongs_to :country
  
  validates	:country_id,		:presence		=> true,
  					:uniqueness		=> true
  validates	:salary_ceiling,	:presence 		=> true
  validates	:startend_date,		:presence		=> true,
  					:numericality		=> { :only_integer => true },
  					:inclusion		=> { :in => 1..28 }
  
end
