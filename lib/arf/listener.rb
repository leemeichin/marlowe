require 'travis'
require 'travis/pro'

class Arf
  class Listener

    STATUSES = {
      broken: ->(build, _) { build.failed? || build.errored? },
      fixed:  ->(previous_build, event) { (previous_build.failed? || previous_build.errored?) && event.build.passed? }
    }

    attr_reader :travis_org

    def initialize(access_token: nil, travis_org: nil)
      Travis::Pro.access_token = access_token
      @travis_org = travis_org
    end

    def listen_for_build_completions!
      Travis::Pro.listen(*repos) do |stream|
        stream.on 'build:finished' do |event|
          case event
          when STATUSES[:broken].curry(event.build)
            Arf::Broken.new(build: event.build)
          when STATUSES[:fixed].curry(event.repository.recent_builds.to_a[-2])
            Arf::Fixed.new(build: event.build)
          end.trigger!
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

  end
end
