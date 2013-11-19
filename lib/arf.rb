require 'led_board'
require 'travis'
require 'travis/pro'
require 'arf/breakage'

module Arf

  ACCESS_TOKEN = ENV['ACCESS_TOKEN']

  attr_reader :board
  attr_accessor :daemonize

  def start!
    PiWire.init
    @board ||= LEDBoard.connect(1)
  end

  def stop!
    board && board.disconnect
  end

  def daemonize!
    if pid = File.read(Arf.pidfile) rescue nil
      raise "An Arf process (#{pid}) is already running. Stop it first."
    end

    Process.daemon and File.write(Arf.pidfile, Process.pid)
  end

end
