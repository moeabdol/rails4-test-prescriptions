require "rails_helper"

describe CreateProject do
  it "creates a project given a name" do
    creator = CreateProject.new(name: "Project Runway")
    creator.build
    expect(creator.project.name).to eq("Project Runway")
  end

  describe "task string parsing" do
    let(:creator) { CreateProject.new(name: "Test", task_string: task_string) }
    let(:tasks) { creator.convert_string_to_tasks }

    describe "with an empty string" do
      let(:task_string) { "" }
      specify { expect(tasks.size).to eq(0) }
    end

    describe "with a single string" do
      let(:task_string) { "Start things" }
      specify { expect(tasks.size).to eq(1) }
      specify { expect(tasks.map(&:title)).to eq(["Start things"]) }
      specify { expect(tasks.map(&:size)).to eq([1]) }
    end

    describe "with a single string and a size" do
      let(:task_string) { "Start things:3" }
      specify { expect(tasks.size).to eq(1) }
      specify { expect(tasks.map(&:title)).to eq(["Start things"]) }
      specify { expect(tasks.map(&:size)).to eq([3]) }
    end

    describe "with multiple tasks" do
      let(:task_string) { "Start things:3\nEnd things:2"}
      specify { expect(tasks.size).to eq(2) }
      specify { expect(tasks.map(&:title)).to \
                eq(["Start things", "End things"]) }
      specify { expect(tasks.map(&:size)).to eq([3, 2]) }
    end

    describe "attaching tasks to the project" do
      let(:task_string) { "Start things:3\nEnd things:2" }

      it "saves the project and tasks" do
        creator.create
        expect(creator.project.tasks.size).to eq(2)
        expect(creator.project).not_to be_a_new_record
      end
    end
  end

  it "adds users to the project" do
    user = User.new
    creator = CreateProject.new(name: "Project Runway", users: [user])
    creator.build
    expect(creator.project.users).to eq([user])
  end
end
