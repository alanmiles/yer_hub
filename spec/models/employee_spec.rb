# == Schema Information
#
# Table name: employees
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  enterprise_id :integer
#  officer       :boolean         default(FALSE)
#  staff_id      :integer
#  left          :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Employee do
  pending "add some examples to (or delete) #{__FILE__}"
end
