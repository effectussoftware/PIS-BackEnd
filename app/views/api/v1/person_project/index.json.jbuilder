json.person_project do
  json.array! @people do |person|
    json.person do
      json.partial! 'api/v1/people/short_info', person: person
      json.projects (@only_active_projects ? person.person_project.active_project : person.person_project) do |person_project|
        json.partial! 'api/v1/projects/short_info', project: person_project.project
        json.dates do
          json.partial! 'dates', date: person_project
          json.partial! 'info', person_project: person_project
        end
      end
    end
  end
end
