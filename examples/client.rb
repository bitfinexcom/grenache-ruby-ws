require 'thin'
require 'pry'
require 'fiber'
require 'grenache-ruby-base'
require_relative "../lib/grenache/base.rb"
require_relative "../lib/grenache/websocket.rb"
require 'benchmark'

Grenache::Base.configure do |conf|
   conf.grape_address = "ws://127.0.0.1:30002"
end

EM.run do

  c = Grenache::Base.new
  tot = 0
  Fiber.new do
    start_time = Time.now
    1000.times do |n|
      c.request("test","world #{n}")
      r = Fiber.yield
      p r
    end
    puts "Total Time: #{Time.now - start_time}"
  end.resume
end
