require 'singleton'
require 'travis'
require 'travis/pro'

module Marlowe
  class Listener

    include Singleton

    def self.listen_for_build_completions!
      client.access_token = Marlowe.token

      client.listen(*repos) do |stream|
        stream.on 'build:finished' do |event|
          if ['passed', 'failed', 'errored'].include? event.build.state
            print_status(event)
            Marlowe::Message.new(event: event, state: event.build.state).send!
          end
        end
      end
    end

    private

    def self.client
      @client ||= Marlowe.pro? ? Travis::Pro : Travis
    end

    def self.print_status(event)
      puts "Build finished: #{event.payload["repository"]["slug"]}\nStatus: #{event.build.state}"
    end

    def self.repos
      @repos ||= client::User.current.session.get("/repos/#{Marlowe.account}")["repos"]
    end

  end
end
