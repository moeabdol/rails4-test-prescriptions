require 'rails_helper'

describe ProjectsController, type: :controller do
  describe "POST create" do
    it "creates project" do
      post :create, project: { name: "Project Runway",
                               tasks: "Start something:2" }
      expect(assigns(:action).project.name).to eq("Project Runway")
      expect(response).to redirect_to(projects_path)
    end

    it "creates a project (mock version)" do
      fake_action = instance_double(CreateProject, create: true)
      expect(CreateProject).to receive(:new).with( name: "Runway",
        task_string: "start something:2").and_return(fake_action)
      post :create, project: { name: "Runway",
                               tasks: "start something:2" }
      expect(assigns(:action)).not_to be_nil
      expect(response).to redirect_to(projects_path)
    end

    it "goes back to the form on failure" do
      post :create, project: { name: "", tasks: "" }
      expect(assigns(:project)).to be_present
      expect(response).to render_template(:new)
    end

    it "fails create gracefully" do
      action_stub = double(create: false, project: Project.new)
      expect(CreateProject).to receive(:new).and_return(action_stub)
      post :create, project: { name: "Project Runway" }
      expect(response).to render_template(:new)
    end
  end

  describe "PATCH update" do
    it "fails update gracefully" do
      sample = Project.create(name: "Test Project")
      expect(sample).to receive(:update_attributes).and_return(false)
      allow(Project).to receive(:find).and_return(sample)
      patch :update, id: sample.id, project: { name: "Fred" }
      expect(response).to render_template(:edit)
    end
  end
end
