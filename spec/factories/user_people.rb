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
FactoryBot.define do
  factory :user_person do
    notification_active { false }
    not_seen { false }
  end
end
