class UpdateProject
  include Interactor
  include Errors

  def call
    return object_not_found!(:project) unless context.project

    return context if context.project.update(name: context.name)

    object_invalid!(:project)
  end
end
