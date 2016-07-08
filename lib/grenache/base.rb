module Grenache
  class Base
    def listen(key, port,  opts={}, &block)
      EM.defer {
        @ws = Websocket.new port, &block
        @ws.start_server
      }

      announce(key, port, opts) do
        puts "#{key} announced"
      end
    end

    def request(key,payload, &cb)
      lookup key do |services|
        service = services.sample
        puts "connect to: #{service}"
        WebsocketClient.new(service,payload,&cb)
      end
    end

  end
end
