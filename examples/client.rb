require 'grenache-ruby-ws'

Grenache::Base.configure do |conf|
   conf.grape_address = "ws://127.0.0.1:30002"
end

EM.run do
  client = Grenache::BaseWs.new
  10.times do |n|
    client.request("test","world #{n}") do |msg|
      puts "#{msg}"
    end
  end
end
