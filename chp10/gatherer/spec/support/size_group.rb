shared_examples "sizeable" do
  let(:instance) { described_class.new }

  it "knows a one-point story is small" do
    allow(instance).to receive(:size).and_return(1)
    expect(instance).to be_small
  end

  it "knows a five-point story is epic" do
    allow(instance).to receive(:size).and_return(5)
    expect(instance).to be_epic
  end
end
