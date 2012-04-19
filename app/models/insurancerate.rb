# == Schema Information
#
# Table name: insurancerates
#
#  id              :integer         not null, primary key
#  country_id      :integer
#  low_salary      :integer
#  high_salary     :integer
#  employer_nats   :decimal(4, 2)
#  employer_expats :decimal(4, 2)
#  employee_nats   :decimal(4, 2)
#  employee_expats :decimal(4, 2)
#  position        :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Insurancerate < ActiveRecord::Base

  belongs_to :country
  
  acts_as_list :scope => :country
  
  attr_accessible :country_id, :low_salary, :high_salary, :employer_nats, :employer_expats, :employee_nats, :employee_expats, :position

  validates	:country_id,		:presence 		=> true
  validates	:low_salary,		:presence 		=> true,
  					:uniqueness		=> { :scope => :country_id }, 
  					:numericality		=> { :only_integer => true, :allow_zero => true }
  validates	:high_salary,		:presence 		=> true,
  					:uniqueness		=> { :scope => :country_id },
  					:numericality		=> { :only_integer => true, :allow_zero => true }
  validates	:employer_nats,		:presence 		=> true,
  					:numericality		=> true,
  					:inclusion		=> { :in => 0..99.99 }
  validates	:employer_expats,	:presence 		=> true,
  					:numericality		=> true,
  					:inclusion		=> { :in => 0..99.99 }
  validates	:employee_nats,		:presence 		=> true,
  					:numericality	 	=> true,
  					:inclusion		=> { :in => 0..99.99 }
  validates	:employee_expats,	:presence 		=> true,
  					:numericality		=> true,
  					:inclusion		=> { :in => 0..99.99 }
  
end
