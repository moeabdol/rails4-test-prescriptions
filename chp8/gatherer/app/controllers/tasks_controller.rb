class TasksController < ApplicationController
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

  def show
    @task = Task.find(params[:id])
  end
end
