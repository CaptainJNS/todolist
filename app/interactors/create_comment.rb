class CreateComment
  include Interactor
  include Errors

  def call
    task = Task.find_by(id: context.task_id)
    return object_not_found!(:task) unless task

    context.comment = Comment.new(task: task, body: context.body, image: context.image)
    return context if context.comment.save

    object_invalid!(:comment)
  end
end
