json.extract! person, :id, :first_name, :last_name, :email, :working_hours, :roles
json.full_name "#{person.first_name} #{person.last_name}"
json.technologies do
  json.array! person.person_technologies.collect do |p_t|
    json.array! [p_t.technology.name, p_t.seniority]
  end
end
