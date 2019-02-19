# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/codecs/json_lines_awslogs"
require "logstash/event"
require "logstash/json"
require "insist"

describe LogStash::Codecs::JSONLinesAWSLogs do
  let(:codec_options) { {} }

  shared_examples :codec do
    context "#encode" do
      let(:data) { {LogStash::Event::TIMESTAMP => "2015-12-07T11:37:00.000Z", "foo" => "bar", "baz" => {"bah" => ["a", "b", "c"]}} }
      let(:event) { LogStash::Event.new(data) }

      it "should return json data" do
        got_event = false
        subject.on_event do |e, d|
          insist { d } == "#{LogStash::Event.new(data).to_json}\n"
          insist { LogStash::Json.load(d)["foo"] } == data["foo"]
          insist { LogStash::Json.load(d)["baz"] } == data["baz"]
          insist { LogStash::Json.load(d)["bah"] } == data["bah"]
          got_event = true
        end
        subject.encode(event)
        insist { got_event }
      end

      context "when using custom delimiter" do
        let(:delimiter) { "|" }
        let(:codec_options) { {"delimiter" => delimiter} }

        it "should decode multiple lines separated by the delimiter" do
          subject.on_event do |e, d|
            insist { d } == "#{LogStash::Event.new(data).to_json}#{delimiter}"
          end
          subject.encode(event)
        end
      end
    end
  end
end
