class CreateProject
  include Interactor

  def call
    context.project = Project.new(user: context.user, name: context.name)

    return context if context.project.save

    context.errors = context.project.errors.full_messages
    context.fail!
  end
end
