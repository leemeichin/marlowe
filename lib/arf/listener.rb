require 'travis'
require 'travis/pro'

class Arf
  class Listener

    attr_reader :travis_account, :travis

    def initialize(access_token: nil, travis_account: nil, pro_account: false)
      @travis = pro_account ? Travis::Pro : Travis # this is a little odd
      @travis_account = travis_account

      @travis.access_token = access_token
    end

    def listen_for_build_completions!
      travis.listen(*repos) do |stream|
        stream.on 'build:finished' do |event|
          if state.include?('passed', 'failed', 'errored')
            print_status(event)
            Arf::Message.new(event: event, state: event.build.state).send!
          end
        end
      end
    end

    private

    def print_status(event)
      puts "Build finished: #{event.payload["repository"]["slug"]}\nStatus: #{event.build.state}"
    end

    def user
      travis::User.current
    end

    def repos
      @repos ||= user.session.get("/repos/#{travis_account}")["repos"]
    end
  end
end
