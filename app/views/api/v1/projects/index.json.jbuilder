json.projects do
  json.array! @projects.includes([:project_technologies]).includes([:technologies]),
              partial: 'info', as: :project
end
