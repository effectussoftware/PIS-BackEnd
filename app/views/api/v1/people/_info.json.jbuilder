json.extract! person, :id, :first_name, :last_name, :email, :working_hours
json.full_name "#{person.first_name} #{person.last_name}"
json.technologies do
  json.array! person.person_technology.collect.each do |p_t|
    [p_t.technology, p_t.seniority]
  end
end