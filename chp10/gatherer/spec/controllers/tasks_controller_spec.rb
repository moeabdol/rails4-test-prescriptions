require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:example) { ActionMailer::Base.deliveries.clear }

  describe "PATCH update" do
    let(:task) { Task.create!(title: "Write section on testing mailers",
                              size: 2) }

    it "does not send an email if a task is not completed" do
      patch :update, id: task.id, task: { size: 3 }
      expect(ActionMailer::Base.deliveries.size).to eq(0)
    end

    it "sends email when task is completed" do
      patch :update, id: task.id, task: { size: 3, completed: true }
      task.reload
      expect(task.completed_at).to be_present
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq("A task has been completed")
      expect(email.to).to eq(["monitor@tasks.com"])
      expect(email.body.to_s).to match(/Write section on testing mailers/)
    end
  end
end
