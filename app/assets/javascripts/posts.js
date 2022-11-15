//=require jquery
$(document).ready(function(){
    $("body")
        .on("submit", "#create_post_form", submitCreatePost)
        .on("submit", ".create_comment_form", submitCreateComment)

        .on("submit", ".delete_post_form", submitDeletePost)
        .on("submit", ".delete_comment_form", submitDeleteComment)
});

function submitCreatePost(){
    let form = $(this);

    $.post(form.attr('action'), form.serialize(), function(data){
        (data.status) ? $("#wall_container").append(data.result.html) : alert(data.error);
    });

    form[0].reset();
    return false;
}

function submitCreateComment(){
    let form = $(this);

    $.post(form.attr('action'), form.serialize(), function(data){
        (data.status) ? $("#post_content_" + data.result.post_id).append(data.result.html) : alert(data.error);
    });

    form[0].reset();
    return false;
}

function submitDeletePost(){
    let form = $(this);

    $.post(form.attr('action'), form.serialize(), function(data){
        (data.status) ? form.closest(".post_container").remove() : alert(data.error);
    });

    return false;
}

function submitDeleteComment(){
    let form = $(this);

    $.post(form.attr('action'), form.serialize(), function(data){
        (data.status) ? form.closest(".comments_list li").remove() : alert(data.error);
    });

    return false;
}