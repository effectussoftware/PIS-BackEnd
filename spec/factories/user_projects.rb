# == Schema Information
#
# Table name: user_projects
#
#  id         :bigint           not null, primary key
#  notify     :boolean          default(FALSE)
#  isvalid    :boolean          default(TRUE)
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user_project do
    notify { false }
    valid { false }
  end
end
