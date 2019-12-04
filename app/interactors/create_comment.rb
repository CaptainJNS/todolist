class CreateComment
  include Interactor
  include Errors

  def call
    return object_not_found!(:task) unless context.params[:task].present?

    context.comment = Comment.new(context.params)
    return context if context.comment.save

    object_invalid!(:comment)
  end
end
