json.project do
  json.partial! 'info', project: @project
  json.technologies do
    json.array! @project.technologies.map(&:name)
  end
end
