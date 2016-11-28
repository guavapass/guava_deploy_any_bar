require 'rubygems'

require 'action_cable_client'
require 'any_bar'

any_bar = AnyBar::Client.new(1738)

EventMachine.run do
  uri = "ws://toilet.guavawesome.com/websocket"
  client = ActionCableClient.new(uri, 'DoorEventChannel')
  # the connected callback is required, as it triggers
  # the actual subscribing to the channel but it can just be
  # client.connected {}
  client.connected { puts 'successfully connected.' }

  # called whenever a message is received from the server
  client.received do | data |
    color = data.try(:[], 'message').try(:[], 'color')

    any_bar.color = color || 'black'
  end

  client.disconnected { any_bar.color = 'question' }
end
