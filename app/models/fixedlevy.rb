# == Schema Information
#
# Table name: fixedlevies
#
#  id              :integer         not null, primary key
#  country_id      :integer
#  name            :string(255)
#  low_salary      :integer
#  high_salary     :integer
#  employer_nats   :decimal(7, 3)   default(0.0)
#  employer_expats :decimal(7, 3)   default(0.0)
#  employee_nats   :decimal(7, 3)   default(0.0)
#  employee_expats :decimal(7, 3)   default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#

class Fixedlevy < ActiveRecord::Base  

  belongs_to :country
  
  attr_accessible :country_id, :name, :low_salary, :high_salary, :employer_nats, :employer_expats, :employee_nats, :employee_expats
  
  validates	:country_id,		:presence 		=> true
  validates	:name,			:presence		=> true,
  					:length			=> { :maximum => 15 },
  					:uniqueness		=> { :scope => :country_id }
  validates	:low_salary,		:presence 		=> true,
  					:numericality		=> { :only_integer => true, :allow_zero => true }
  validates	:high_salary,		:presence 		=> true,
  					:numericality		=> { :only_integer => true, :allow_zero => true }
  validates	:employer_nats,		:presence 		=> true,
  					:numericality		=> true,
  					:inclusion		=> { :in => 0..9999.999 }
  validates	:employer_expats,	:presence 		=> true,
  					:numericality		=> true,
  					:inclusion		=> { :in => 0..9999.999 }
  validates	:employee_nats,		:presence 		=> true,
  					:numericality	 	=> true,
  					:inclusion		=> { :in => 0..9999.999 }
  validates	:employee_expats,	:presence 		=> true,
  					:numericality		=> true,
  					:inclusion		=> { :in => 0..9999.999 }
  
end
