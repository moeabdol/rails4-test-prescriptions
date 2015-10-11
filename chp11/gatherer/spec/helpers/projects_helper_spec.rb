require 'rails_helper'

RSpec.describe ProjectsHelper, type: :helper do
  let(:project) { Project.new(name: "Project Runway") }

  it "augments with status info" do
    allow(project).to receive(:on_schedule?).and_return(true)
    actual = helper.name_with_status(project)
    expect(actual).to have_selector("span.on_schedule", text: "Project Runway")
  end

  it "augments with status info when behind schedule" do
    allow(project).to receive(:on_schedule?).and_return(false)
    actual = helper.name_with_status(project)
    expect(actual).to have_selector("span.behind_schedule",
                                    text: "Project Runway")
  end
end
