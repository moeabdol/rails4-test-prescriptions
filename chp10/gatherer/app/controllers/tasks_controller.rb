class TasksController < ApplicationController
  def show
    @task = Task.find(params[:id])
  end

  def create
    @project = Project.find(params[:task][:project_id])
    @project.tasks.create(title: params[:task][:title],
                          size: params[:task][:size],
                          project_order: @project.next_task_order)
    redirect_to @project
  end

  def update
    @task = Task.find(params[:id])
    completed = params[:task].delete(:completed)
    params[:task][:completed_at] = Time.now if completed
    if @task.update_attributes(params[:task].permit(:size, :completed_at))
      TaskMailer.task_completed_email(@task).deliver_now if completed
      redirect_to @task, notice: "'task was successfully updated.'"
    else
      render :edit
    end
  end

  def up
    @task = Task.find(params[:id])
    @task.move_up
    redirect_to @task.project
  end

  def down
    @task = Task.find(params[:id])
    @task.move_down
    redirect_to @task.project
  end
end
