include ApplicationHelper

class PostsController < ApplicationController
    # Check first if the user is logged, before doing any actions
    before_action :is_session_exist?

    # DOCU: This will render the dashboard page
    def dashboard
        @all_posts = Post.get_all_posts()[:result]
    end

    # DOCU: This will process the saving of new post
    def create
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            validate_fields = validate_fields(params, [:message])

            if validate_fields[:status]
                response_data = Post.create_post(params.merge!({ :user_id => session[:user_id] }))

                if response_data[:status]
                    response_data[:result][:html] = render_to_string :partial => "posts/partials/post_lists",
                        :locals => {
                            :posts => [{
                                "post_id" => response_data[:result][:post_id],
                                "post_owner_id" => session[:user_id],
                                "first_name" => session[:first_name],
                                "message" => params[:message]
                            }]
                        }
                else

                end
            else
                response_data[:error] = "Please enter your message."
            end
        rescue => exception
            response_data[:error] = exception.message
        end

        render :json => response_data
    end

    # DOCU: This will process the deleting of post
    def delete
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            validate_fields = validate_fields(params, [:post_id])

            if validate_fields[:status]
                response_data = Post.delete_post(params.merge!({ :user_id => session[:user_id] }))
            else
                response_data[:error] = "Post id is required."
            end
        rescue => exception
            response_data[:error] = exception.message
        end

        render :json => response_data
    end

    private
        # DOCU: This will check if user is loggedin, else redirect to "/"
        def is_session_exist?
            redirect_to "/" if !session[:user_id].present?
        end
end
