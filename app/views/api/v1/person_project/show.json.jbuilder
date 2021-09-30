json.person_project do
  json.partial! 'info', person_project: @person_project

  json.project do
    json.id @person_project.project.id
    json.name @person_project.project.name
  end
end
