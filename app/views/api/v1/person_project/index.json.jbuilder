json.person_project do
  json.array! @people do |person|
    json.person do
      json.partial! 'api/v1/people/short_info', person: person
      json.projects person.projects do |project|
        json.partial! 'api/v1/projects/short_info', project: project
        json.dates project.person_project.where(person_id: person) do |person_project|
          json.partial! 'dates', date: person_project
          json.partial! 'info', person_project: person_project
        end
      end
    end
  end
end
