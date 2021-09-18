# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string
#  start_date  :date             not null
#  end_date    :date             not null
#  budget      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :project do
    name { 'Proyecto 1' }
    description { 'Desc. generica' }
    start_date { '2021-09-11' }
    end_date { '2021-09-11' }
    budget { 1 }
  end
end
