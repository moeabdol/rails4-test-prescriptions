require "rails_helper"

describe "project routing" do
  it "routes projects" do
    expect(get: "/projects").to route_to(controller: "projects",
                                         action: "index")
    expect(post: "/projects").to route_to(controller: "projects",
                                          action: "create")
    expect(get: "/projects/new").to route_to(controller: "projects",
                                            action: "new")
    expect(get: "/projects/1").to route_to(controller: "projects",
                                           action: "show", id: "1")
    expect(get: "/projects/1/edit").to route_to(controller: "projects",
                                               action: "edit", id: "1")
    expect(patch: "/projects/1").to route_to(controller: "projects",
                                            action: "update", id: "1")
    expect(delete: "/projects/1").to route_to(controller: "projects",
                                              action: "destroy", id: "1")
  end
end
