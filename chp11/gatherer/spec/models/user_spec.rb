require 'rails_helper'

RSpec.describe User, type: :model do
  RSpec::Matchers.define :be_able_to_see do |*projects|
    match do |user|
      expect(user.visible_projects).to eq(projects)
      projects.all? { |p| expect(user.can_view?(p)).to be_truthy }
      (all_projects - projects).all? { |p| expect(user.can_view?(p)).to \
        be_falsy }
    end
  end

  describe "visibility" do
    let(:user) { User.create!(email: "user@example.com", password: "password") }
    let(:project_1) { Project.create!(name: "Project 1") }
    let(:project_2) { Project.create!(name: "Project 2") }
    let(:all_projects) { [project_1, project_2]}

    before(:context) { Project.delete_all }

    it "allows a user to see their projects" do
      user.projects << project_1
      expect(user).to be_able_to_see(project_1)
    end

    it "allows an admin to see all projects" do
      user.admin = true
      expect(user).to be_able_to_see(project_1, project_2)
    end

    it "allows a user to see public projects" do
      user.projects << project_1
      project_2.update_attributes(public: true)
      expect(user).to be_able_to_see(project_1, project_2)
    end

    it "has no dupes in project list" do
      user.projects << project_1
      project_1.update_attributes(public: true)
      expect(user).to be_able_to_see(project_1)
    end
  end
end
