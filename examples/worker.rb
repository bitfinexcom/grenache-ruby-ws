require 'thin'
require 'grenache-ruby-base'
require_relative "../lib/grenache/base-ws.rb"
require_relative "../lib/grenache/websocket.rb"

Grenache::Base.configure do |conf|
   conf.grape_address = "ws://127.0.0.1:30002"
end

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  c = Grenache::BaseWs.new

  c.listen('test',5004) do |ws,msg|
    ws.send Oj.dump("hello #{msg.data}")
  end

end
