# == Schema Information
#
# Table name: entabsencedefs
#
#  id               :integer         not null, primary key
#  enterprise_id    :integer
#  category         :string(255)
#  abbreviation     :string(255)
#  description      :string(255)
#  max_per_year     :integer
#  salary_deduction :integer         default(0)
#  sickness         :boolean         default(FALSE)
#  push             :boolean         default(FALSE)
#  inactive         :boolean         default(FALSE)
#  updated_by       :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Entabsencedef < ActiveRecord::Base

  belongs_to :enterprise
  
  attr_accessible :enterprise_id, :category, :abbreviation, :description, :max_per_year, :salary_deduction, :sickness, :push, :inactive

  validates	:enterprise_id,			:presence	=> true	
  validates	:category,			:presence 	=> true,
  						:length		=> { :maximum => 50 },
  						:uniqueness	=> { :scope => :enterprise_id }
  validates	:abbreviation,			:presence 	=> true,
  						:length		=> { :is => 2 },
  						:uniqueness	=> { :scope => :enterprise_id }
  validates	:max_per_year,			:numericality	=> { :only_integer => true, :allow_nil => true }
  validates	:salary_deduction,		:numericality	=> { :only_integer => true },
  						:inclusion	=> { :in => 0..100 }
  

end
