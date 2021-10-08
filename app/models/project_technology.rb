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

  def self.add_technology(project_id, technology_name)
    technology = Technology.find_or_create_single(technology_name)
    technology_id = technology.id
    project_technology = ProjectTechnology.find_by project_id: project_id,
                                                   technology_id: technology_id
    if project_technology.blank?
      project_technology = ProjectTechnology.create!(project_id: project_id,
                                                     technology_id: technology_id)
      return project_technology
    end
    nil
  end

  # Retorna solo las nuevas
  def self.add_project_technologies(project_id, technologies)
    res = []
    technologies.each do |tech|
      new_tech = ProjectTechnology.add_technology(project_id, tech)
      res.push new_tech unless new_tech.nil?
    end
    res
  end
end
