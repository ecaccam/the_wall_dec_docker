class Comment < ApplicationRecord
    # DOCU: This will process the saving of comment in DB
    def self.create_comment(params)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            insert_comment_id = insert_record([
                "INSERT INTO comments (post_id, user_id, message, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())",
                 params[:post_id], params[:user_id], params[:message]
            ])

            if insert_comment_id > 0
                response_data[:status] = true
                response_data[:result] = { :post_id => params[:post_id], :comment_id => insert_comment_id }
            end
        rescue => exception
            response_data[:error] = exception.message
        end

        return response_data
    end

    # DOCU: This will process the delete of comments in DB
    def self.delete_comment(params)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            delete_comment = delete_record(["DELETE FROM comments WHERE id=? AND user_id =?", params[:comment_id], params[:user_id]])

            if delete_comment
                response_data[:status] = true
            else
                response_data[:error] = "You cannot delete comment you don't own."
            end
        rescue => exception
            response_data[:error] = exception.message
        end

        return response_data
    end
end
