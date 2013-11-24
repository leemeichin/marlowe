require 'led_board'
require 'marlowe/listener'
require 'marlowe/message'
require 'ostruct'

module Marlowe

  def self.configure(&block)
    @config = OpenStruct.new(account: nil, token: nil, pro: false).tap(&block)
  end

  def self.account
    @config.account
  end

  def self.token
    @config.token
  end

  def self.pro?
    @config.pro
  end

  def self.start!
    Marlowe::Listener.listen_for_build_completions!
  end

end
