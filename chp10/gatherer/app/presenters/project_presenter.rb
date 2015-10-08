class ProjectPresenter < SimpleDelegator
  def self.from_project_list(*projects)
    projects.flatten.map { |project| ProjectPresenter.new(project) }
  end

  def initialize(project)
    super
  end

  def name_with_status
    dom_class = on_schedule? ? "on_schedule": "behind_schedule"
    "<span class='#{dom_class}'>#{name}</span>"
  end
end
