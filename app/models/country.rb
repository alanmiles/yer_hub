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
  
  after_create :build_insurancerule
  
  belongs_to :nationality
  belongs_to :currency
  has_one :insurancerule, :dependent => :destroy
  has_many :insurancerates, :dependent => :destroy
  has_many :gratuityrates, :dependent => :destroy
  has_many :sicknessallowances, :dependent => :destroy
  
  validates	:country,		:presence	=> true,
  					:length		=> { :maximum => 50 },
  					:uniqueness	=> { :case_sensitive => false }
  validates	:currency_id,		:presence	=> true
  validates	:nationality_id,	:presence 	=> true  

  
  private
  
    def build_insurancerule
      @insurancerule = Insurancerule.new(:country_id => self.id)
      @insurancerule.save 
    end
end
