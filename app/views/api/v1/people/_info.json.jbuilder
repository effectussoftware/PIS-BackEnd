json.extract! person, :id, :first_name, :last_name, :email, :working_hours, :roles
json.full_name "#{person.first_name} #{person.last_name}"
