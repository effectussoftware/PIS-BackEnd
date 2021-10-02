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
FactoryBot.define do
  factory :user_person do
    notify { "" }
    isvalid { false }
  end
end
