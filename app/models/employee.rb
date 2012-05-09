# == Schema Information
#
# Table name: employees
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  enterprise_id :integer
#  officer       :boolean         default(FALSE)
#  staff_id      :integer
#  left          :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

class Employee < ActiveRecord::Base

  belongs_to :user
  belongs_to :enterprise
  
  attr_accessible :user_id, :enterprise_id, :officer, :staff_id, :left
  
  validates	:user_id,		:presence 	=> true,
  					:uniqueness	=> { :scope => :enterprise_id }
  validates	:enterprise_id,		:presence	=> true
  validates	:staff_id,		:numericality	=> { :only_integer => true },
  					:uniqueness	=> { :scope => :enterprise_id }  
end
