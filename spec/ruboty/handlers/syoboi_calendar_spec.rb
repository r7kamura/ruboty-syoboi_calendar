require "spec_helper"

describe Ruboty::Handlers::SyoboiCalendar do
  let(:instance) do
    described_class.new(robot)
  end

  let(:robot) do
    Ruboty::Robot.new
  end

  let(:dummy_channels_response) do
    <<-EOS.strip_heredoc
      <?xml version="1.0" encoding="UTF-8"?>
      <ChLookupResponse>
        <Result>
          <Code>200</Code>
          <Message>
          </Message>
        </Result>
        <ChItems>
          <ChItem id="3">
            <ChComment>DummyComment</ChComment>
            <ChEPGURL>http://example.com/epg-url</ChEPGURL>
            <ChGID>1</ChGID>
            <ChID>3</ChID>
            <ChName>DummyChannelName</ChName>
            <ChNumber>3</ChNumber>
            <ChURL>http://example.com/</ChURL>
            <ChiEPGName>DummyiEPGName</ChiEPGName>
            <LastUpdate>2000-01-01 00:00:00</LastUpdate>
          </ChItem>
        </ChItems>
      </ChLookupResponse>
    EOS
  end

  let(:dummy_programs_response) do
    <<-EOS.strip_heredoc
      <?xml version="1.0" encoding="UTF-8"?>
      <ProgLookupResponse>
        <ProgItems>
          <ProgItem id="1">
            <ChID>3</ChID>
            <Count>1</Count>
            <Deleted>0</Deleted>
            <EdTime>2000-01-01 00:00:00</EdTime>
            <Flag>9</Flag>
            <LastUpdate>2000-01-01 00:00:00</LastUpdate>
            <PID>1</PID>
            <ProgComment>DummyComment</ProgComment>
            <Revision>2</Revision>
            <STSubTitle>DummySubTitle</STSubTitle>
            <StOffset>0</StOffset>
            <StTime>2000-01-01 00:00:00</StTime>
            <SubTitle></SubTitle>
            <TID>2</TID>
            <Warn>1</Warn>
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
            <Cat>4</Cat>
            <Comment>DummyComment</Comment>
            <FirstCh>DummyChannel</FirstCh>
            <FirstEndMonth>1</FirstEndMonth>
            <FirstEndYear>2000</FirstEndYear>
            <FirstMonth>1</FirstMonth>
            <FirstYear>2000</FirstYear>
            <Keywords>DummyKeywords</Keywords>
            <LastUpdate>2000-01-01 00:00:00</LastUpdate>
            <ShortTitle>DummyShortTitle</ShortTitle>
            <SubTitles>DummySubTitles</SubTitles>
            <TID>2</TID>
            <Title>DummyTitle</Title>
            <TitleEN>DummyEnglishTitle</TitleEN>
            <TitleFlag>0</TitleFlag>
            <TitleYomi>ダミータイトル</TitleYomi>
            <UserPoint>6</UserPoint>
            <UserPointRank>1</UserPointRank>
          </TitleItem>
        </TitleItems>
      </TitleLookupResponse>
    EOS
  end

  let(:app) do
    ->(env) do
      [
        200,
        { "Content-type" => "application/xml" },
        [
          case env["QUERY_STRING"]
          when /ProgLookup/
            dummy_programs_response
          when /ChLookup/
            dummy_channels_response
          else
            dummy_titles_response
          end,
        ],
      ]
    end
  end

  describe "#list" do
    before do
      stub_request(:get, /cal.syoboi.jp/).to_rack(app)
    end

    let(:message) do
      {
        body: "@ruboty list anime",
        from: "test",
        to: "ruboty",
      }
    end

    it "replies today's anime list" do
      Ruboty.logger.should_receive(:info).with("2000-01-01 00:00 DummyTitle #1 (DummyChannelName)")
      robot.receive(message)
    end
  end
end
