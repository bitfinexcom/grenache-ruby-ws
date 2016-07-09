require 'thin'
require 'pry'
require 'grenache-ruby-base'
require_relative "../lib/grenache/base.rb"
require_relative "../lib/grenache/websocket.rb"
require 'benchmark'

Grenache::Base.configure do |conf|
   conf.grape_address = "ws://127.0.0.1:30002"
end

EM.run do

  c = Grenache::Base.new
  d1 = Time.now
  count = 0
  500.times do |n|
    c.request("test","world #{n}") do |msg|
      puts "#{msg} // #{count}"
      count +=1
    end
  end
  d2 = Time.now

  puts d2-d1
end
