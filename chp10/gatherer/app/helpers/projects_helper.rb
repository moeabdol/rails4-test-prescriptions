module ProjectsHelper

  def name_with_status(project)
    dom_class = project.on_schedule? ? "on_schedule" : "behind_schedule"
    content_tag(:span, project.name, class: dom_class)
  end
end
