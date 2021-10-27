# == Schema Information
#
# Table name: user_people
#
#  id                  :bigint           not null, primary key
#  notification_active :boolean          default(FALSE)
#  not_seen            :boolean          default(TRUE)
#  user_id             :integer
#  person_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_user_people_on_person_id  (person_id)
#  index_user_people_on_user_id    (user_id)
#
require 'rails_helper'

RSpec.describe UserPerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
