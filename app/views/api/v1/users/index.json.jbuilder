json.administrators do
  json.array! @admins, partial: 'info', as: :user
end
