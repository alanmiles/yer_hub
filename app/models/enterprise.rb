# == Schema Information
#
# Table name: enterprises
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  short_name           :string(255)
#  company_registration :integer
#  address_1            :string(255)
#  address_2            :string(255)
#  address_3            :string(255)
#  town                 :string(255)
#  district             :string(255)
#  zipcode              :string(255)
#  country_id           :integer
#  home_airport         :string(255)
#  sector_id            :string(255)
#  mission              :text
#  values               :text
#  terms_accepted       :boolean         default(FALSE)
#  setup_step           :integer         default(1)
#  inactive             :boolean         default(FALSE)
#  created_by           :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class Enterprise < ActiveRecord::Base

  belongs_to :country
  belongs_to :sector
  
  has_one :enterpriseparameter, :dependent => :destroy
  has_many :entabsencedefs, :dependent => :destroy
  has_many :employees, :dependent => :destroy
  
  attr_accessible :name, :short_name, :company_registration, :address_1, :address_2, :address_3, :town, :district, :zipcode, :country_id,
  		  :home_airport, :sector_id, :mission, :values, :terms_accepted, :setup_step, :inactive, :created_by

  after_create  :build_related_models
  
  validates	:name,			:presence	=> true,
  					:length		=> { :maximum => 50 },
  					:uniqueness	=> { :case_sensitive => false, :scope => :country_id }
  validates	:short_name,		:presence	=> true,
  					:length		=> { :maximum => 10 }
  validates	:country_id,		:presence	=> true
  validates	:sector_id,		:presence	=> true
  validates	:home_airport,		:length		=> { :maximum => 30, :allow_blank => true }
  validates	:company_registration,	:numericality 	=> { :integer_only => true, :allow_nil => true }
  validates	:created_by,		:numericality	=> { :integer_only => true } 
  
  #validate that terms have been accepted in the controller
  
  private
  
    def build_related_models
      if terms_accepted?
        Enterpriseparameter.create(:enterprise_id => id)
        @abscats = Abscat.where("approved = ?", true)
        @abscats.each do |a|
          Entabsencedef.create(:enterprise_id => id, :category => a.category, :abbreviation => a.abbreviation)
        end
        Business.create(:enterprise_id => id, :business_name => name, :short_name => short_name, :address_1 => address_1, 
      			:address_2 => address_2, :address_3 => address_3, :town => town, :district => district,
      			:zipcode => zipcode, :country_id => country_id, :home_airport => home_airport, :sector_id => sector_id,
			:mission => mission, :values => values)
			 
        Employee.create(:user_id => self.created_by, :enterprise_id => self.id, :officer => true, :staff_id => 1)
      
      end   		
    end
end
