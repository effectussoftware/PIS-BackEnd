json.projects do
  json.array! @projects,
              partial: 'info', as: :project
end
