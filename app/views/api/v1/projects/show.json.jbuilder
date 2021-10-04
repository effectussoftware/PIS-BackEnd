json.project do
  json.partial! 'info', project: @project
  json.technologies do
    json.array! @project.technologies.collect do |tech|
      tech.name
    end
  end
end
