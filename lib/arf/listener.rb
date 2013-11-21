require 'travis'
require 'travis/pro'

class Arf
  class Listener

    attr_reader :travis_org

    def initialize(access_token: nil, travis_org: nil)
      Travis::Pro.access_token = access_token
      @travis_org = travis_org
    end

    def listen_for_build_completions!
      Travis::Pro.listen(*repos) do |stream|
        stream.on 'build:finished' do |event|
          puts "Build finished: #{event.payload["repository"]["slug"]}\n Status: #{event.build.state}"

          Arf::Broken.new(event: event).transmit! if build_broken?(event)
          Arf::Fixed.new(event: event).transmit! if build_fixed?(event)
        end
      end
    end

    private

    def user
      Travis::Pro::User.current
    end

    def repos
      @repos ||= user.session.get("/repos/#{travis_org}")["repos"]
    end

    def build_broken?(event)
      event.build.failed? || event.build.errored?
    end

    def build_fixed?(event)
      event.build.passed?
    end

  end
end
