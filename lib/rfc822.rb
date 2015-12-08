require 'timeout'
require 'uri'

module RFC822

  module Patterns

    ATOM      = "[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\u00ff]+"

    QTEXT     = "[^\\x0d\\x22\\x5c\\u0080-\\u00ff]"
    QPAIR     = "\\x5c[\\x00-\\x7f]"
    QSTRING   = "\\x22(?:#{QTEXT}|#{QPAIR})*\\x22"

    WORD      = "(?:#{ATOM}|#{QSTRING})"

    LOCAL_PT  = "#{WORD}(?:\\x2e#{WORD})*"
    ADDRESS   = "#{LOCAL_PT}\\x40(?:#{URI::REGEXP::PATTERN::HOSTNAME})?#{ATOM}"

  end

  MXRecord = Struct.new(:priority, :host)
  EMAIL    = /\A#{Patterns::ADDRESS}\z/

  @@host_command = '/usr/bin/env host'

  class << self

    def host_command
      @@host_command
    end

    def host_command=(value)
      @@host_command = value
    end

    def mx_records(address)
      address = address.to_s
      return [] unless address =~ EMAIL

      Timeout::timeout(2) do
        raw_mx_records(address.split('@').last).map do |priority, host|
          MXRecord.new(priority.to_i, host)
        end
      end
    rescue Timeout::Error
      []
    end

    def raw_mx_records(domain)
      host_mx(domain).scan(/#{Regexp.escape(domain)}[\w ]+?(\d+) (#{URI::REGEXP::PATTERN::HOSTNAME})\./)
    end

    def host_mx(domain)
      `#{host_command} -t MX #{domain}`
    end

  end
end
