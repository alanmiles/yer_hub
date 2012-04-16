# == Schema Information
#
# Table name: countries
#
#  id             :integer         not null, primary key
#  country        :string(255)
#  nationality_id :integer
#  currency_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Country < ActiveRecord::Base

  attr_accessible :country, :nationality_id, :currency_id
  
  belongs_to :nationality
  belongs_to :currency
  has_one :insurancerule, :dependent => :destroy
  
  validates	:country,		:presence	=> true,
  					:length		=> { :maximum => 50 },
  					:uniqueness	=> { :case_sensitive => false }
  validates	:currency_id,		:presence	=> true
  validates	:nationality_id,	:presence 	=> true  

  def self.list_excluding_insrules_taken
    already_taken = []
    @insurancerules = Insurancerule.all
    @insurancerules.each do |i|
      already_taken << i.country_id
    end 
    if already_taken.count == 0 
      self.order("country")
    else
      countries_table = Arel::Table.new(:countries)
      self.where(countries_table[:id].not_in already_taken).order("country")
    end
  end
  
  def self.list_excluding_insrules_taken_except(current)
    already_taken = []
    @insurancerules = Insurancerule.where("country_id != ?", current)
    @insurancerules.each do |i|
      already_taken << i.country_id
    end
    if already_taken.count == 0 
      self.order("country")
    else
      countries_table = Arel::Table.new(:countries)
      self.where(countries_table[:id].not_in already_taken).order("country")
    end
  end
end
