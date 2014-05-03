require "spec_helper"

describe Ellen::Handlers::SyoboiCalendar do
  let(:instance) do
    described_class.new(robot)
  end

  let(:robot) do
    Ellen::Robot.new
  end

  describe "#initialize" do
    it "is successfully initialized" do
      instance.should be_true
    end
  end
end
