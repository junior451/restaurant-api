require 'sinatra/base'
require_relative 'customers'
require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

get '/customers' do
  h = {}
  @customers = Customers.all
  @customers.each do |c|
    h[c.id] = {name: c.name, date: c.completed_at}
  end

  h.to_json
end

# class App < Sinatra::Base
#
#   get '/' do
#     erb :index
#   end
#
#   get '/customers' do
#     h = {}
#     @customers = Customers.all
#     @customers.each do |c|
#       h[c.id] = {name: c.name, date: c.completed_at}
#     end
#
#     h.to_json
#
#
#     # @customers = Customers.get(params[:id])
#     # h[:name] = @customers.name
#     # h[:date] = @customers.completed_at.to_s
#     # h.to_s
#     # erb :customers
#   end
# end


__END__
@@ index
<html>
<title>
</title>
<body>
<p>Hello World</p>
</body>
</html>

@@ customers
<html>
<title>
</title>
<body>
<% @customers.each do |c| %>
  <p> <%= c.name %> : <%= c.completed_at %></p>
<% end %>
</body>
</html>