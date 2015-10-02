require 'rails_helper'

describe ProjectsController, type: :controller do
  describe "POST create" do
    it "creates project" do
      post :create, project: { name: "Project Runway",
                               tasks: "Start something:2" }
      expect(response).to redirect_to(projects_path)
      expect(assigns(:action).project.name).to eq("Project Runway")
    end

    it "goes back to the form on failure" do
      post :create, project: { name: "", tasks: "" }
      expect(response).to render_template(:new)
      expect(assigns(:project)).to be_present
    end
  end
end
