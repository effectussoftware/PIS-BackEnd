json.project do
  json.array! @projects, partial: 'info', as: :project
end
