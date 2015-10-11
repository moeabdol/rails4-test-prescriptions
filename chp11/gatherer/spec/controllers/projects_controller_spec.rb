require 'rails_helper'

describe ProjectsController, type: :controller do
  let(:user) { User.create!(email: "rspec@example.com", password: "password") }

  before(:example) do
    sign_in(user)
  end

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
        task_string: "start something:2", users: [user]).and_return(fake_action)
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

  describe "Get show" do
    let(:project) { Project.create!(name: "Project Runway") }

    it "allows a user who is part of the project to see the project" do
      #controller.current_user.stubs(can_view?: true)
      allow(controller.current_user).to receive(:can_view?).and_return(true)
      get :show, id: project.id
      expect(response).to render_template(:show)
    end

    it "does not allow user who is not part of project to see the project" do
      #controller.current_user.stubs(can_view?: false)
      allow(controller.current_user).to receive(:can_view?).and_return(false)
      get :show, id: project.id
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET index" do
    it "displays all projects correctly" do
      user = User.new
      project = Project.new(name: "Project Greenlight")
      expect(controller).to receive(:current_user).and_return(user)
      expect(user).to receive(:visible_projects).and_return([project])
      get :index
      expect(assigns(:projects).map(&:__getobj__)).to eq([project])
    end
  end
end
