# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120426162027) do

  create_table "abscats", :force => true do |t|
    t.string   "category"
    t.string   "abbreviation"
    t.boolean  "approved",     :default => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "country"
    t.integer  "nationality_id"
    t.integer  "currency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", :force => true do |t|
    t.string   "currency"
    t.string   "abbreviation"
    t.integer  "dec_places"
    t.decimal  "change_to_dollars", :precision => 8, :scale => 5
    t.boolean  "approved",                                        :default => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fixedlevies", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.integer  "low_salary"
    t.integer  "high_salary"
    t.decimal  "employer_nats",   :precision => 7, :scale => 3, :default => 0.0
    t.decimal  "employer_expats", :precision => 7, :scale => 3, :default => 0.0
    t.decimal  "employee_nats",   :precision => 7, :scale => 3, :default => 0.0
    t.decimal  "employee_expats", :precision => 7, :scale => 3, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gratuityrates", :force => true do |t|
    t.integer  "country_id"
    t.integer  "service_years_from"
    t.integer  "service_years_to"
    t.decimal  "resignation_rate",     :precision => 5, :scale => 2
    t.decimal  "non_resignation_rate", :precision => 5, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insurancerates", :force => true do |t|
    t.integer  "country_id"
    t.integer  "low_salary"
    t.integer  "high_salary"
    t.decimal  "employer_nats",   :precision => 4, :scale => 2
    t.decimal  "employer_expats", :precision => 4, :scale => 2
    t.decimal  "employee_nats",   :precision => 4, :scale => 2
    t.decimal  "employee_expats", :precision => 4, :scale => 2
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insurancerules", :force => true do |t|
    t.integer  "country_id"
    t.integer  "salary_ceiling",   :default => 1000000
    t.boolean  "startend_prorate", :default => true
    t.integer  "startend_date",    :default => 15
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legislations", :force => true do |t|
    t.integer  "country_id"
    t.integer  "retirement_men",       :default => 65
    t.integer  "retirement_women",     :default => 60
    t.boolean  "sickness_accruals",    :default => false
    t.integer  "max_sickness_accrual", :default => 0
    t.integer  "probation_days",       :default => 90
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levies", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.integer  "low_salary"
    t.integer  "high_salary"
    t.decimal  "employer_nats",   :precision => 4, :scale => 2, :default => 0.0
    t.decimal  "employer_expats", :precision => 4, :scale => 2, :default => 0.0
    t.decimal  "employee_nats",   :precision => 4, :scale => 2, :default => 0.0
    t.decimal  "employee_expats", :precision => 4, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nationalities", :force => true do |t|
    t.string   "nationality"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "occupations", :force => true do |t|
    t.string   "occupation"
    t.boolean  "approved",   :default => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sectors", :force => true do |t|
    t.string   "sector"
    t.boolean  "approved",   :default => false
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sicknessallowances", :force => true do |t|
    t.integer  "country_id"
    t.integer  "sick_days_from"
    t.integer  "sick_days_to"
    t.integer  "deduction_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.boolean  "administrator",      :default => false
    t.string   "pin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
