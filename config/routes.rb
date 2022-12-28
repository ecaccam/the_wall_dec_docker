Rails.application.routes.draw do
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

    # DOCU: Route for post functions
    scope "posts" do
        post "/create" => "posts#create"
        post "/delete" => "posts#delete"
    end
    
    # DOCU: Route for comment functions
    scope "comments" do
        post "/create" => "comments#create"
        post "/delete" => "comments#delete"
    end
end
