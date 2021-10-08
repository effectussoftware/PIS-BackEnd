json.technologies do
  json.array! @technologies, partial: 'info', as: :technology
end
