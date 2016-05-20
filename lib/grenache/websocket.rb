module Grenache
  class Websocket
    def initialize(port)
      @port = port
    end

    def self.call(env)
    end

    def start_server
      @server = Thin::Server.start('0.0.0.0', @port, method(:app))
    end

    def app(env)
      ws = Faye::WebSocket.new(env)
      ws.on(:message, method(:on_message))
      ws.on(:close, method(:on_close))
      ws.rack_response
    end

    def on_message(ev)
    end

    def on_close(ev)
    end
  end
end
