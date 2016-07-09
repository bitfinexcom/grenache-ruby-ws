module Grenache
  class Base
    def listen(key, port,  opts={}, &block)
      EM.defer {
        @ws = WebsocketServer.new port, &block
        @ws.start_server
      }

      announce(key, port, opts) do |res|
        puts "#{key} announced #{res}"
      end
    end

    def request(key, payload, &cb)
      lookup key do |services|
        service = services.sample
        ws = WebsocketClient.new(service,&cb)
        ws.send Oj.dump(payload)
      end
    end

  end
end
