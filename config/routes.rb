Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "users#login"

  # DOCU: Routes for login and register
  scope "users" do
    get  "/register" => "users#register"
    post "/register" => "users#register"
    post "/login"    => "users#login"
    get "/logout"    => "users#logout"
  end

  # DOCU: Route for dashboard page
  get "/dashboard" => "posts#dashboard"

  # DOCU: Routes for post feature
  scope "posts" do
    post "/create" => "posts#create"
    post "/delete" => "posts#delete"
  end

  # DOCU: Routes for comment feature
  scope "comments" do
    post "/create" => "comments#create"
    post "/delete" => "comments#delete"
  end
end
