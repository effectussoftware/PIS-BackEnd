# == Schema Information
#
# Table name: technologies
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_technologies_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :technology do
    name { Faker::ProgrammingLanguage.unique.name.downcase.strip }
  end
end
