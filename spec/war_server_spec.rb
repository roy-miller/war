require 'spec_helper'
require 'war_server'
require 'mock_war_socket_client'

def capture_stdout(&block)
  old = $stdout
  $stdout = fake = StringIO.new
  block.call
  fake.string
ensure
  $stdout = old
end

describe 'WarServer' do
  # before :each do
  #   @server = WarServer.new(2000)
  #   @server_thread = Thread.new { @server.start }
  # end
  #
  # after :each do
  #   @server_thread.exit
  # end

  describe '#initialize' do
    it 'blah' do
      server = WarServer.new(2001)
      Thread.new { server.start }
      expect(server).to be_a WarServer
    end
  end

  describe '#start' do
    it 'responds with a welcome message' do
      server = WarServer.new(2002)
      Thread.new { server.start }
      client = MockWarSocketClient.new(2002)
      client.capture_output
      expect(client.output).to eq "Welcome to war!\n"
    end
  end

  describe '#ask_for_name' do
    it 'prompts player for name' do
      server = WarServer.new(2003)
      response = capture_stdout { server.ask_for_name }
      expect(response).to eq "Enter your name:\n"
    end
  end
end
