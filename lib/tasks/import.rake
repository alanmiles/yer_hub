namespace :import do
  
  desc "populate database with data from nationalities.csv"
  task :add_nationalities => :environment do
    lines = File.new('public/data/nationalities.csv').readlines
    header = lines.shift.strip
    keys = header.split(';')
    lines.each do |line|
      params = {}
      values = line.strip.split(';')
      keys.each_with_index do |key, i|
        params[key] = values[i]
      end
      Nationality.create(params)
    end
  end
  
  desc "populate database with data from currencies.csv"
  task :add_currencies => :environment do
    @admin = User.find_by_name("Alan Miles")
    lines = File.new('public/data/currencies.csv').readlines
    header = lines.shift.strip
    keys = header.split(';')
    lines.each do |line|
      params = {}
      values = line.strip.split(';')
      keys.each_with_index do |key, i|
        params[key] = values[i]
      end
      Currency.create(params)
      @currency = Currency.last
      @currency.update_attribute(:created_by, @admin.id)
    end
  end
  
  desc "populate database with data from countries.csv"
  task :add_countries => :environment do
    lines = File.new('public/data/countries.csv').readlines
    header = lines.shift.strip
    keys = header.split(';')
    lines.each do |line|

      values = line.strip.split(';')
      @country = values[0]
      @nat = values[1]
      @cur = values[2]
      @nationality = Nationality.find_by_nationality(@nat)
      @currency = Currency.find_by_abbreviation(@cur)
      @attr = { :country => @country, :nationality_id => @nationality.id, :currency_id => @currency.id }
      Country.create(@attr)
    end
  end
  
  desc "populate database with data from sectors.csv"
  task :add_sectors => :environment do
    @admin = User.find_by_name("Alan Miles")
    lines = File.new('public/data/sectors.csv').readlines
    header = lines.shift.strip
    keys = header.split(',')
    lines.each do |line|
      params = {}
      values = line.strip.split(',')
      keys.each_with_index do |key, i|
        params[key] = values[i]
      end
      Sector.create(params)
      @sector = Sector.last
      @sector.update_attribute(:created_by, @admin.id)
    end
  end
  
  desc "Run all import tasks"
  task :all => [:add_nationalities, :add_currencies, :add_countries, :add_sectors]
end
