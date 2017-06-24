require_relative '../lib/grenache-ruby-ws.rb'

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  c = Grenache::Ws.new grape_address: "http://127.0.0.1:40002/"
  port = 5004

  c.listen('rpc_test', port) do |req|
    [nil,"hello #{req.payload}"]
  end

end
