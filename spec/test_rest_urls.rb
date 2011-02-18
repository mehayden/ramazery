
require 'ramaze'
require 'ramaze/spec/bacon'

require __DIR__('../app')

describe TestRestPeachesController do
  behaves_like :rack_test

  # test all the primary patterns for peaches
  should 'list peaches' do
    get('/test/rest/peaches').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: list/
    last_response.should =~ /path_info: \/list/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/list/
  end

  should 'give new peaches' do
    get('/test/rest/peaches/new').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: new/
    last_response.should =~ /path_info: \/new/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/new/
  end

  should 'create a new peach' do
    post('/test/rest/peaches').status.should == 201
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: create/
    last_response.should =~ /path_info: \/create/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/create/
  end

  should 'show peach 17' do
    get('/test/rest/peaches/17').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: show/
    last_response.should =~ /id: 17/
    last_response.should =~ /path_info: \/show\/17/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/show\/17/
  end

  should 'edit peach 17' do
    get('/test/rest/peaches/17/edit').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: edit/
    last_response.should =~ /id: 17/
    last_response.should =~ /path_info: \/edit\/17/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/edit\/17/
  end

  should 'update peach 17' do
    put('/test/rest/peaches/17').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: update/
    last_response.should =~ /id: 17/
    last_response.should =~ /path_info: \/update\/17/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/update\/17/
  end

  should 'delete peach 666' do
    delete('/test/rest/peaches/666').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: delete/
    last_response.should =~ /id: 666/
    last_response.should =~ /path_info: \/delete\/666/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/delete\/666/
  end

  # test the work-around patterns for unsupported HTTP methods PUT, DELETE
  should 'update peach 17' do
    post('/test/rest/peaches/17?_method=PUT').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: update/
    last_response.should =~ /id: 17/
    last_response.should =~ /path_info: \/update\/17/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/update\/17/
  end

  should 'delete peach 666' do
    post('/test/rest/peaches/666?_method=DELETE').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: delete/
    last_response.should =~ /id: 666/
    last_response.should =~ /path_info: \/delete\/666/
    last_response.should =~ /fullpath: \/test\/rest\/peaches\/delete\/666/
  end

end

describe TestRestCreamController do
  behaves_like :rack_test

  # test the list pattern for cream so we know another collection works too
  should 'list cream' do
    get('/test/rest/cream').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /method: list/
    last_response.should =~ /path_info: \/list/
    last_response.should =~ /fullpath: \/test\/rest\/cream\/list/
  end
end
