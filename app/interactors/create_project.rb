class CreateProject
  include Interactor

  def call
    if project_exist?
      context.errors = [I18n.t('errors.project_exist')]
      return context.fail!
    end

    context.project = Project.new(user: context.user, name: context.name)

    return context if context.project.save

    context.errors = context.project.errors.full_messages
    context.fail!
  end

  private

  def project_exist?
    Project.find_by(user: context.user, name: context.name)
  end
end
