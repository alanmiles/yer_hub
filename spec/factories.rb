# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
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



