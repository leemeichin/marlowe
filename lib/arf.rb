require 'led_board'
require 'arf/listener'
require 'arf/led_notification'
require 'arf/broken'
require 'arf/fixed'

class Arf

  attr_reader :board
  attr_accessor :daemonize, :travis_org, :access_token, :pidfile, :logfile

  def connect_board
    @board ||= LEDBoard.connect(1)
  end

  def start!
    connect_board
    Arf::Listener.new(access_token: access_token, travis_org: travis_org).listen_for_build_completions!
  end

  def stop!
    board && board.disconnect

    if daemonize
      pidfile.delete
    end
  end

  def daemonize!
    return unless daemon

    if pid = File.read(pidfile) rescue nil
      raise "An Arf process (#{pid}) is already running. Stop it first."
    end

    if Process.daemon
      pidfile.open {|f| f.write(Process.pid) }
    end
  end

end
