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

  describe "#list" do
    let(:message) do
      {
        body: "@ellen list anime",
        from: "test",
        to: "ellen",
      }
    end

    it "responds to '@ellen list anime'" do
      Ellen.logger.should_receive(:info).with("Not yet implemented")
      robot.receive(message)
    end
  end
end
