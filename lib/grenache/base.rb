module Grenache
  class Base
    def listen(key, port,  opts={}, &block)
      EM.defer {
        @ws = Websocket.new port, &block
        @ws.start_server
      }

      announce(key, port, opts) do |res|
        puts "#{key} announced #{res}"
      end
    end

    def request(key, payload, &block)
      f = Fiber.current
      lookup key do |services|
        f.resume services
      end
      services = Fiber.yield

      f = Fiber.current
      ws = WebsocketClient.new services.sample
      ws.sync_send Oj.dump(payload) do |msg|
        f.resume msg
      end
    end

  end
end
