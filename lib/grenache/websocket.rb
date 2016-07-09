Faye::WebSocket.load_adapter('thin')

module Grenache
  class WebsocketServer
    def initialize(port, &block)
      @port = port
      @callback = block
    end

    def start_server
      @server = Thin::Server.start('0.0.0.0', @port, method(:app), {signals: false})
    end

    def app(env)
      ws = Faye::WebSocket.new(env)
      on_message = -> (ev) { @callback.call(ws, ev) }
      ws.on :message, on_message
      ws.rack_response
    end

    def on_message(ev)
      @callback.call(@ws,ev)
    end

    def send(payload)
      @server.send(payload)
    end

    def on_close(ev)
      puts "ws closed"
    end

  end

  class WebsocketClient
    def initialize(uri, &cb)
      @uri = uri.gsub("tcp","ws")
      @callback = cb
    end

    def send payload
      ws_connect unless @connected
      @ws.send(payload)
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
      @callback.call(msg)
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
