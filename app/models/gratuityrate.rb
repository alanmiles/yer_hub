# == Schema Information
#
# Table name: gratuityrates
#
#  id                   :integer         not null, primary key
#  country_id           :integer
#  service_years_from   :integer
#  service_years_to     :integer
#  resignation_rate     :decimal(5, 2)   percentage of 1 month's salary to accrue per year of service
#  non_resignation_rate :decimal(5, 2)
#  created_at           :datetime
#  updated_at           :datetime
#

class Gratuityrate < ActiveRecord::Base

  attr_accessible :country_id, :service_years_from, :service_years_to, :resignation_rate, :non_resignation_rate
  
  belongs_to :country
  
  validates	:country_id,		:presence		=> true
  validates	:service_years_from,	:presence		=> true,
  					:numericality		=> { :only_integer => true },
  					:uniqueness		=> { :scope => :country_id }
  validates	:service_years_to,	:presence		=> true,
  					:numericality		=> { :only_integer => true },
  					:uniqueness		=> { :scope => :country_id }
  validates	:resignation_rate,	:presence		=> true,
  					:numericality		=> true
   validates	:non_resignation_rate,	:presence		=> true,
  					:numericality		=> true
  						 
  		
  					
end
