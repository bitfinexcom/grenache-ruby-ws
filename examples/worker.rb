require_relative '../lib/grenache-ruby-ws.rb'

Grenache::Ws.configure do |conf|
   conf.grape_address = "ws://127.0.0.1:30001"
end

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }
  c = Grenache::Ws.new

  c.listen('rpc_test',5004) do |req|
    [nil,"hello #{req.payload}"]
  end

end
