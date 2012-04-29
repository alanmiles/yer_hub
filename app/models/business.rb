# == Schema Information
#
# Table name: businesses
#
#  id            :integer         not null, primary key
#  enterprise_id :integer
#  business_name :string(255)
#  short_name    :string(255)
#  address_1     :string(255)
#  address_2     :string(255)
#  address_3     :string(255)
#  town          :string(255)
#  district      :string(255)
#  zipcode       :string(255)
#  country_id    :integer
#  home_airport  :string(255)
#  sector_id     :integer
#  mission       :text
#  values        :text
#  share_mission :boolean         default(FALSE)
#  setup_step    :integer         default(1)
#  inactive      :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

class Business < ActiveRecord::Base

  belongs_to :country
  belongs_to :sector
  
  has_one :bizparameter, :dependent => :destroy
  has_many :bizabsencedefs, :dependent => :destroy
  
  attr_accessible :enterprise_id, :business_name, :short_name, :address_1, :address_2, :address_3, :town, :district, :zipcode, :country_id,
  		  :home_airport, :sector_id, :mission, :values, :share_mission, :setup_step, :inactive

  after_create :build_linked_tables
  
  validates	:business_name,		:presence 		=> true,
  					:length			=> { :maximum => 50 },
  					:uniqueness 		=> { :case_sensitive => false, :scope => :enterprise_id }
  validates	:short_name,		:presence	=> true,
  					:length		=> { :maximum => 15 }
  validates	:country_id,		:presence	=> true
  validates	:sector_id,		:presence	=> true
  validates	:home_airport,		:length		=> { :maximum => 30, :allow_blank => true }
 
 
  private
  
    def build_linked_tables
      Bizparameter.create(:business_id => self.id)
      @enterprise = Enterprise.find(self.enterprise_id)
      @abscats = Entabsencedef.where("enterprise_id = ? and inactive = ?", @enterprise.id, false)
      @abscats.each do |a|
        Bizabsencedef.create(:business_id => self.id, :category => a.category, :abbreviation => a.abbreviation)
      end
    end
end
