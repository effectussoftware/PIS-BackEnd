json.notifications do
  json.array! @notifications, partial: 'info', as: :notification
end
