# == Schema Information
#
# Table name: bizparameters
#
#  id                   :integer         not null, primary key
#  business_id          :integer
#  daily_salary_rate    :decimal(4, 2)   default(30.0)
#  hourly_salary_rate   :decimal(5, 2)   default(176.0)
#  ot_multiplier_1      :decimal(3, 2)   default(1.25)
#  ot_multiplier_2      :decimal(3, 2)   default(1.5)
#  ot_multiplier_3      :decimal(3, 2)   default(2.0)
#  standard_weekend_1   :integer         default(6)
#  standard_weekend_2   :integer         default(7)
#  vacation_calculation :boolean         default(FALSE)
#  payroll_close        :integer         default(15)
#  push_changes         :boolean         default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#

class Bizparameter < ActiveRecord::Base

  belongs_to :business
  
  attr_accessible :business_id, :daily_salary_rate, :hourly_salary_rate, :ot_multiplier_1, :ot_multiplier_2, :ot_multiplier_3,
                  :standard_weekend_1, :standard_weekend_2, :vacation_calculation, :payroll_close, :push_changes

  validates	:business_id, 		:presence 	=> true,
  					:uniqueness	=> true
  validates	:daily_salary_rate,	:numericality	=> true
  validates	:hourly_salary_rate,	:numericality	=> true
  validates	:ot_multiplier_1,	:numericality	=> true
  validates	:payroll_close,		:numericality	=> { :only_integer => true }
  validates	:ot_multiplier_2,	:numericality	=> true, :allow_nil => true
  validates	:ot_multiplier_3,	:numericality	=> true, :allow_nil => true
  validates	:standard_weekend_1,	:numericality	=> { :only_integer => true, :allow_nil => true }
  validates	:standard_weekend_2,	:numericality	=> { :only_integer => true, :allow_nil => true }
  
end
