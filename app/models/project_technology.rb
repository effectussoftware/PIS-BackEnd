# == Schema Information
#
# Table name: project_technologies
#
#  id            :bigint           not null, primary key
#  project_id    :bigint           not null
#  technology_id :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_project_technologies_on_project_id                    (project_id)
#  index_project_technologies_on_project_id_and_technology_id  (project_id,technology_id) UNIQUE
#  index_project_technologies_on_technology_id                 (technology_id)
#
class ProjectTechnology < ApplicationRecord
  belongs_to :project
  belongs_to :technology

  validates :project_id, uniqueness: { scope: [:technology_id] }
end
