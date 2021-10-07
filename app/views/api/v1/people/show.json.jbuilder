json.person do
  json.partial! 'info', person: @person
  json.technologies do
    json.array! @person.person_technologies.includes(:technology).collect do |p_t|
      json.array! [p_t.technology.name, p_t.seniority]
    end
  end
end
