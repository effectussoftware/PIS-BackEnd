json.person_project do
  json.id @person_project.id
  json.person do
    json.partial! 'api/v1/people/info', person: @person_project.person.reload
  end
  json.partial! 'info', person_project: @person_project
  json.project do
    json.partial! 'api/v1/projects/medium_info', project: @person_project.project
  end
end
