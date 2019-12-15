class CreateComment
  include Interactor
  include Errors

  def call
    return object_not_found!(:task) unless context.task

    context.comment = context.task.comments.build(context.params)
    return context if context.comment.save

    object_invalid!(:comment)
  end
end
