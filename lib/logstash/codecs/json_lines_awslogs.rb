# encoding: utf-8
require "logstash/codecs/base"
require "logstash/util/charset"
require "logstash/util/buftok"
require "logstash/json"

class LogStash::Codecs::JSONLinesAWSLogs < LogStash::Codecs::Base
  config_name "json_lines_awslogs"

  # Change the delimiter that separates lines
  config :delimiter, :validate => :string, :default => "\n"

  public

  def decode(data, &block)
    raise "Not implemented"
  end

  def encode(event)
    # Tack on a @delimiter for now because previously most of logstash's JSON
    # outputs emitted one per line, and whitespace is OK in json.
    @on_event.call(event, "#{event.to_s} #{event.to_json}#{@delimiter}")
  end
end
