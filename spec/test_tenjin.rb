
require 'ramaze'
require 'ramaze/spec/bacon'

require __DIR__('../app')

describe TestTenjinController do
  behaves_like :rack_test

  should 'show nested content' do
    get('/test_tenjin').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.body.strip.should =~ /<p>Level one content<\/p>
<p class="L2">Level two A content<\/p>
<p class="L3">Level three with helper output: MY_TEST_HELPER OUTPUT<\/p>
<p class="L2">Level two A with instance variable: INST_VAR_TWO<\/p>
<p>More level one content<\/p>
<p class="L2">Level two B content<\/p>
<p>Level one with instance variable: INST_VAR_ONE<\/p>/
  end

end
