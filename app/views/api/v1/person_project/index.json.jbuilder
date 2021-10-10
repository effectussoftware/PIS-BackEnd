json.person_project do
  json.array! @people do |person|
    json.person do
      json.id person.id
      json.full_name "#{person.first_name} #{person.last_name}"
      json.projects person.projects do |project|
        json.id project.id
        json.name project.name
        json.dates project.person_project do |person_project|
          json.id person_project.id
          json.rol person_project.rol
          json.start_date person_project.start_date
          json.end_date person_project.end_date
        end
      end
    end
  end
end
