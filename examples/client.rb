require 'thin'
require 'pry'
require 'grenache-ruby-base'
require_relative "../lib/grenache/base.rb"
require_relative "../lib/grenache/websocket.rb"

Grenache::Base.configure do |conf|
   conf.grape_address = "ws://127.0.0.1:30002"
end

EM.run {
c = Grenache::Base.new

c.request("test",'hello') do |msg|
  puts msg
  EM.stop
end

}
