json.people do
  json.array! @people, partial: 'info', as: :person
end
