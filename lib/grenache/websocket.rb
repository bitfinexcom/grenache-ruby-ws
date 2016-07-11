Faye::WebSocket.load_adapter('thin')

module Grenache
  class Websocket
    def initialize(port, &block)
      @port = port
      @callback = block
    end

    def start_server
      @server = Thin::Server.start('0.0.0.0', @port, method(:app), {signals: false})
    end

    def app(env)
      @ws = Faye::WebSocket.new(env)
      @ws.on(:message, method(:on_message))
      @ws.on(:close, method(:on_close))
      @ws.rack_response
    end

    def on_message(ev)
      @callback.call(@ws,ev)
    end

    def send(payload)
      @server.send(payload)
    end

    def on_close(ev)
      puts "service CLOSE: #{ev}"
    end

    class Response
      def initializer(server, response)
        @server = server
        @response = response
      end

      def send(payload)
        @server.send(payload)
      end

      def response; @response; end
    end
  end

  class WebsocketClient
    def initialize(uri)
      @uri = uri.gsub("tcp","ws")
    end

    def send payload
      ws_connect unless @connected
      @ws.send(payload)
    end

    def sync_send payload, &block
      @block = block
      send payload
    end

    private
    def ws_connect
      @ws = Faye::WebSocket::Client.new(@uri)
      @ws.on(:open, method(:on_open))
      @ws.on(:message, method(:on_message))
      @ws.on(:close, method(:on_close))
    end

    def on_open(ev)
      @connected = true
    end

    def on_message(ev)
      msg = Oj.load(ev.data)
      disconnect
      @block.call(msg) if @block
    end

    def disconnect
      @ws.close
      @ws = nil
    end

    def on_close(ev)
      @connected = false
    end
  end
end
