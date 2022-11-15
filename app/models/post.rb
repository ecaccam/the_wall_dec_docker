class Post < ApplicationRecord
    # DOCU: This will fetch all the posts and comments
    def self.get_all_posts()
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            response_data[:status] = true
            response_data[:result] = query_records([
                "SELECT 
                    posts.id AS post_id, posts.user_id AS post_owner_id, posts.message, users.first_name,
                    IF(
                        comments.id IS NOT NULL,
                        JSON_ARRAYAGG(
                            JSON_OBJECT(
                                'comment_id', comments.id,
                                'commenter_user_id', comments.user_id,
                                'commenter_first_name', comment_users.first_name,
                                'commenter_first_name', comment_users.first_name,
                                'commenter_message', comments.message
                            )
                        ),
                        NULL
                    ) AS post_comments
                FROM posts
                INNER JOIN users ON users.id = posts.user_id
                LEFT JOIN comments ON comments.post_id = posts.id
                LEFT JOIN users AS comment_users ON comment_users.id = comments.user_id
                GROUP BY posts.id"
            ])
        rescue => exception
            response_data[:error] = exception.message
        end

        return response_data
    end

    # DOCU: This will process the saving of post in DB
    def self.create_post(params)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            insert_post_id = insert_record([
                "INSERT INTO posts (user_id, message, created_at, updated_at) VALUES (?, ?, NOW(), NOW())",
                 params[:user_id], params[:message]
            ])

            if insert_post_id > 0
                response_data[:status] = true
                response_data[:result] = { :post_id => insert_post_id }
            end
        rescue => exception
            response_data[:error] = exception.message
        end

        return response_data
    end

    # DOCU: This will process the delete of post and its comments in DB
    def self.delete_post(params)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            # Check if post has comments, then delete it also
            post_comments = query_record(["SELECT JSON_ARRAYAGG(id) AS delete_comment_ids FROM comments WHERE post_id =?", params[:post_id]])

            if post_comments.present? && post_comments["delete_comment_ids"].present?
                delete_comment_records = delete_record(["DELETE FROM comments WHERE post_id IN (?)", JSON.parse(post_comments["delete_comment_ids"])])
            end

            delete_post = delete_record(["DELETE FROM posts WHERE id =? AND user_id =?", params[:post_id], params[:user_id]])

            if delete_post > 0
                response_data[:status] = true
            else
                response_data[:error] = "You cannot delete post you don't own."
            end
        rescue => exception
            response_data[:error] = exception.message
        end

        return response_data
    end
end
