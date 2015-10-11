require "rails_helper"

describe "adding projects" do
  fixtures :all
  include Warden::Test::Helpers

  before(:example) do
    login_as users(:user)
  end

  it "allows a user to create a project with tasks" do
    visit new_project_path
    fill_in "Name", with: "Project Runway"
    fill_in "Tasks", with: "Task 1:3\nTask 2:5"
    click_on "Create Project"
    visit projects_path
    @project = Project.find_by_name("Project Runway")
    expect(page).to have_selector(
      "#project_#{@project.id} .name", text: "Project Runway")
    expect(page).to have_selector(
      "#project_#{@project.id} .total-size", text: "8")
  end
end
