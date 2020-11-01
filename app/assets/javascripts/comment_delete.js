$("#comments_area").html(
  "= j(render 'index', { comments: @comment.post.comments})"
);
$("#comment-body").val("");
