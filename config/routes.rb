Rails.application.routes.draw do
  post "/api/users", to: "users#create"
end
