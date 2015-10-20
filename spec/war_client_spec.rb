require 'spec_helper'

describe WarClient do
  let(:client) { WarClient.new }
  before do
    @server = WarServer.new
  end
  after do
    @server.stop
  end
  xit 'connects to server and gets unique id'

  # it 'connects to server and gets unique id' do
  #   client.connect
  #   expect(client.unique_id).to eq 1 # how not have a magic number?
  # end
end
