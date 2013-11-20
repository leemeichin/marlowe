require 'led_board'
require 'arf/travis'
require 'arf/led_notification'
require 'arf/broken'
require 'arf/fixed'

module Arf

  ACCESS_TOKEN = ENV['ACCESS_TOKEN']
  TRAVIS_ORG = ENV['TRAVIS_ORG']

  attr_reader :board
  attr_accessor :daemon

  module_function

  def start!
    PiWire.init
    @board ||= LEDBoard.connect(1)
    Arf::Travis.new(access_token: self::ACCESS_TOKEN).listen_for_build_completions!
  end

  def stop!
    board && board.disconnect

    if daemon
      Arf.pidfile.delete
    end
  end

  def daemonize!
    if pid = File.read(Arf.pidfile) rescue nil
      raise "An Arf process (#{pid}) is already running. Stop it first."
    end

    if Process.daemon
      Arf.pidfile.open {|f| f.write(Process.pid) }
      self.daemon = true
    end
  end

end
