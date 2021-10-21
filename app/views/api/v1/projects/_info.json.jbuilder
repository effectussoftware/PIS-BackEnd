json.extract! project,
              :id,
              :name,
              :description,
              :start_date,
              :end_date,
              :project_state,
              :project_type,
              :budget,
              :organization
json.people do
  json.array! project.people, partial: 'api/v1/people/short_info', as: :person
end
json.technologies do
  json.array! project.technologies.map(&:name)
end
