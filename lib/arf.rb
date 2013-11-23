require 'led_board'
require 'arf/listener'
require 'arf/led_notification'
require 'arf/broken'
require 'arf/fixed'

class Arf

  attr_reader :travis_account, :pro_account, :access_token, :listener

  def initialize(options)
    options.each do |key, val|
      instance_variable_set :"@#key", val
    end
  end

  def start!
    @listener ||= Arf::Listener.new(
      access_token: access_token,
      travis_org: travis_account,
      pro_account: pro_account
    ).listen_for_build_completions!
  end

end
