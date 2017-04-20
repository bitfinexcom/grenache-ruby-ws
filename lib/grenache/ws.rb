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
      json = Message.req(key,payload).to_json
      if service_cache[key] && service_cache[key].connected?
        service_cache[key].send json
      else
        service_cache.delete(key)
        lookup key do |services|
          if services.length > 0
            service = services.sample
            service_cache[key] = WebsocketClient.new(service, &cb)
            service_cache[key].send json
          else
            cb.call ["NoServiceFound", nil]
          end
        end
      end
    end

    def service_cache
      @service_cache ||= {}
    end

  end
end
