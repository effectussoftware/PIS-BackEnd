# == Schema Information
#
# Table name: person_projects
#
#  id         :bigint           not null, primary key
#  person_id  :integer          not null
#  project_id :integer          not null
#  rol        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_person_projects_on_person_id_and_project_id  (person_id,project_id) UNIQUE
#
require 'rails_helper'

RSpec.describe PersonProject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
