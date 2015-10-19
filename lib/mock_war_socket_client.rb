require 'socket'

class MockWarSocketClient
  attr_reader :socket

  def initialize(port: 2000)
    @port = port
  end

  def start
    @socket = TCPSocket.open('localhost', @port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @captured_output = @socket.read_nonblock(1000)
    #@output = @socket.gets
  rescue IO::WaitReadable
    @captured_output = ""
    retry
  end

  def output
    capture_output
    @captured_output
  end
end
