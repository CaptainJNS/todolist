class UpdateProject
  include Interactor

  def call
    context.status = :unprocessable_entity

    if project_exist?
      context.errors = [I18n.t('errors.project_exist')]
      return context.fail!
    end

    context.project = Project.find_by(user: context.user, id: context.id)

    unless context.project
      context.status = :not_found
      context.errors = [I18n.t('errors.project_not_found')]
      return context.fail!
    end

    return context if context.project.update(name: context.name)

    context.errors = context.project.errors.full_messages
    context.fail!
  end

  private

  def project_exist?
    Project.find_by(user: context.user, name: context.name)
  end
end
