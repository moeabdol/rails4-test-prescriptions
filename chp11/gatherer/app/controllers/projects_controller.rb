class ProjectsController < ApplicationController
  def index
    @projects = ProjectPresenter.from_project_list(current_user.visible_projects)
  end

  def new
    @project = Project.new
  end

  def create
    @action = CreateProject.new(name: params[:project][:name],
                                task_string: params[:project][:tasks],
                                users: [current_user])
    success = @action.create
    if success
      redirect_to projects_path
    else
      @project = @action.project
      render :new
    end
  end

  def show
    @project = Project.find(params[:id])
    unless current_user.can_view?(@project)
      redirect_to new_user_session_path
      return
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project, notice: "'project was successfully updated.'"
    else
      render :edit
    end
  end
end
