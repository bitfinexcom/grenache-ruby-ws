module Grenache
  class NoPeerFoundError < Exception; end

  class Ws < Grenache::Base
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
        if services.length > 0
          json = Message.req(key,payload).to_json
          service = services.sample
          ws = WebsocketClient.new(service, &cb)
          ws.send json
        else
          cb.call ["NoServiceFound", nil]
        end
      end
    end

  end
end
