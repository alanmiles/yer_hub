# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.administrator	     true
end

Factory.sequence :name do |n|
  "Person #{n}"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :currency do |currency|
  currency.currency		"UAE Dirham"
  currency.abbreviation		"AED"
  currency.dec_places		2
  currency.change_to_dollars	0.2722
  currency.created_by		1
end

Factory.define :note do |note|
  note.title			"Title"
  note.content			"This is the content."
end

Factory.define :nationality do |nationality|
  nationality.nationality	"Emirati"
end

Factory.define :country do |country|
  country.country		"United Arab Emirates"
  country.association :nationality
  country.association :currency
end

Factory.define :sector do |sector|
  sector.sector			"Logistics"
  sector.created_by		1
end

Factory.define :occupation do |occupation|
  occupation.occupation		"Sales"
  occupation.created_by		1
end

Factory.define :abscat do |abscat|
  abscat.category		"Unpaid leave"
  abscat.abbreviation		"UL"
  abscat.created_by		1
end

Factory.define :insurancerule do |insurancerule|
  insurancerule.association :country
end

Factory.define :insurancerate do |insurancerate|
  insurancerate.association :country
  insurancerate.low_salary 	0
  insurancerate.high_salary	4000
  insurancerate.employer_nats	11
  insurancerate.employer_expats	3
  insurancerate.employee_nats	6
  insurancerate.employee_expats	0
end

Factory.define :gratuityrate do |gratuityrate|
  gratuityrate.association :country
  gratuityrate.service_years_from	3
  gratuityrate.service_years_to		5
  gratuityrate.resignation_rate		50
  gratuityrate.non_resignation_rate	100
end

Factory.define :sicknessallowance do |sicknessallowance|
  sicknessallowance.association :country
  sicknessallowance.sick_days_from	15
  sicknessallowance.sick_days_to	30
  sicknessallowance.deduction_rate	50
end

Factory.define :levy do |levy|
  levy.association :country
  levy.name 		"ABCD"
  levy.low_salary 	0
  levy.high_salary	4000
  levy.employer_nats	11
  levy.employer_expats	3
  levy.employee_nats	6
  levy.employee_expats	0
end

Factory.define :fixedlevy do |fixedlevy|
  fixedlevy.association :country
  fixedlevy.name 		"ABCD"
  fixedlevy.low_salary 	 	0
  fixedlevy.high_salary		100000
  fixedlevy.employer_nats	10
  fixedlevy.employer_expats	1.500
  fixedlevy.employee_nats	4.500
  fixedlevy.employee_expats	0
end

Factory.define :enterprise do |enterprise|
  enterprise.name		"The New Company"
  enterprise.short_name		"NewCo"
  enterprise.association :country
  enterprise.association :sector
  enterprise.terms_accepted	true
  enterprise.created_by		1
end
  
