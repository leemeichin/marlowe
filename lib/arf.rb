require 'led_board'
require 'arf/travis'
require 'arf/led_notification'
require 'arf/broken'
require 'arf/fixed'

module Arf

  ACCESS_TOKEN = ENV['ACCESS_TOKEN']

  attr_reader :board
  attr_accessor :daemon

  def start!
    PiWire.init
    @board ||= LEDBoard.connect(1)
    Arf::Travis.new(ACCESS_TOKEN).listen_for_build_completions!
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

  module_function :daemonize!

end
