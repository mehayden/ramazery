# Define a subclass of Ramaze::Controller holding your defaults for all
# controllers

class Controller < Ramaze::Controller
  layout :default
  helper :xhtml
  engine :Etanni
end

# inlcude router modules
require __DIR__('routes/rest_urls')

# register routers with Ramaze
# set up for testing Rest
TestRestCollections = [:peaches, :cream]
TestRestRoot = '/test/rest/'
Ramaze::Route('REST Dispatch') do |path, request|
  Routes::Rest.route(path, request, TestRestRoot, TestRestCollections)
end

# Here go your requires for subclasses of Controller:
require __DIR__('main')
require __DIR__('test_tenjin')
require __DIR__('test_rest_urls')
