require "rails_helper"

describe "projects/index", type: :view do
  let(:completed_task) { Task.create!(completed_at: 1.day.ago, size: 1) }
  let(:on_schedule) { Project.create!(due_date: 1.year.from_now,
                                      name: "On Schedule",
                                      tasks: [completed_task]) }
  let(:incomplete_task) { Task.create!(size: 1) }
  let(:behind_schedule) { Project.create!(due_date: 1.day.from_now,
                                          name: "Behind Schedule",
                                          tasks: [incomplete_task]) }

  it "renders the index page with correct dom elements" do
    @projects = [on_schedule, behind_schedule]
    render
    expect(rendered).to have_selector(
      "#project_#{on_schedule.id} .on_schedule", text: "On Schedule",
      count: 1)
    expect(rendered).to have_selector(
      "#project_#{behind_schedule.id} .behind_schedule",
      text: "Behind Schedule", count: 1)
  end
end
