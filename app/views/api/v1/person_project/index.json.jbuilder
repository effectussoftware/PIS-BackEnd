json.person do
  json.id @person.id
  json.full_name "#{@person.first_name} #{@person.last_name}"
  json.projects @person.person_project do |person_project|
    json.id person_project.project.id
    json.name person_project.project.name
    json.start_date person_project.start_date
    json.end_date person_project.end_date
  end
end
