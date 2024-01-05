Rails.application.routes.draw do
  post "/api/users", to: "users#create"
  post "/api/users/login", to: "users#login"
end
