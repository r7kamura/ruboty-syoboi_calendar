require "spec_helper"

describe Ellen::Handlers::SyoboiCalendar do
  let(:instance) do
    described_class.new(robot)
  end

  let(:robot) do
    Ellen::Robot.new
  end

  let(:dummy_programs_response) do
    <<-EOS.strip_heredoc
      <?xml version="1.0" encoding="UTF-8"?>
      <ProgLookupResponse>
        <ProgItems>
          <ProgItem id="1">
            <LastUpdate>2000-01-01 00:00:00</LastUpdate>
            <PID>1</PID>
            <TID>2</TID>
            <StTime>2000-01-01 00:00:00</StTime>
            <StOffset>0</StOffset>
            <EdTime>2000-01-01 00:00:00</EdTime>
            <Count>1</Count>
            <SubTitle></SubTitle>
            <ProgComment></ProgComment>
            <Flag>9</Flag>
            <Deleted>0</Deleted>
            <Warn>1</Warn>
            <ChID>3</ChID>
            <Revision>2</Revision>
            <STSubTitle></STSubTitle>
          </ProgItem>
        </ProgItems>
        <Result>
          <Code>200</Code>
          <Message>
          </Message>
        </Result>
      </ProgLookupResponse>
    EOS
  end

  let(:dummy_titles_response) do
    <<-EOS.strip_heredoc
      <?xml version="1.0" encoding="UTF-8"?>
      <TitleLookupResponse>
        <Result>
          <Code>200</Code>
          <Message>
          </Message>
        </Result>
        <TitleItems>
          <TitleItem id="2">
            <TID>2</TID>
            <LastUpdate>2000-01-01 00:00:00</LastUpdate>
            <Title>DummyTitle</Title>
            <ShortTitle></ShortTitle>
            <TitleYomi>ダミータイトル</TitleYomi>
            <TitleEN></TitleEN>
            <Comment></Comment>
            <Cat>4</Cat>
            <TitleFlag>0</TitleFlag>
            <FirstYear>2000</FirstYear>
            <FirstMonth>1</FirstMonth>
            <FirstEndYear>2000</FirstEndYear>
            <FirstEndMonth>1</FirstEndMonth>
            <FirstCh>DummyChannel</FirstCh>
            <Keywords></Keywords>
            <UserPoint>6</UserPoint>
            <UserPointRank>1</UserPointRank>
            <SubTitles></SubTitles>
          </TitleItem>
        </TitleItems>
      </TitleLookupResponse>
    EOS
  end

  let(:app) do
    ->(env) do
      if env["QUERY_STRING"] =~ /ProgLookup/
        [200, { "Content-type" => "application/xml" }, [dummy_programs_response]]
      else
        [200, { "Content-type" => "application/xml" }, [dummy_titles_response]]
      end
    end
  end

  describe "#list" do
    before do
      stub_request(:get, /cal.syoboi.jp/).to_rack(app)
    end

    let(:message) do
      {
        body: "@ellen list anime",
        from: "test",
        to: "ellen",
      }
    end

    it "replies today's anime list" do
      Ellen.logger.should_receive(:info).with("2000-01-01 00:00 DummyTitle 1")
      robot.receive(message)
    end
  end
end
