# == Schema Information
#
# Table name: user_people
#
#  id         :bigint           not null, primary key
#  notify     :boolean          default(FALSE)
#  is_valid   :boolean          default(TRUE)
#  user_id    :integer
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe UserPerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
