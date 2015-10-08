class TaskMailer < ApplicationMailer
  default from: "from@example.com"

  def task_completed_email(task)
    @task = task
    mail(to: "monitor@tasks.com", subject: "A task has been completed")
  end
end
