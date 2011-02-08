# Default url mappings are:
#  a controller called Main is mapped on the root of the site: /
#  a controller called Something is mapped on: /something
# If you want to override this, add a line like this inside the class
#  map '/otherurl'
# this will force the controller to be mounted on: /otherurl

class TestTenjinController < Controller
  layout :t_tenjin
  engine :Tenjin

  # the following can control which options are passed to the Tenjin Engine
  #self.trait[:tenjin_options] = {:cache => true}

  helper :t_helper    # a test helper
  # the following can control which helpers will extend the tenjin context
  #self.trait[:tenjin_helpers] = []	# this turns off all helpers
  #self.trait[:tenjin_helpers] = [:t_helper] # this specifies which helpers to use
  # by default all helpers will be used to extend the context

  # the index action is called automatically when no other action is specified
  def index
    @title = "Tenjin"
    @inst_var_one = "INST_VAR_ONE"
    @inst_var_two = "INST_VAR_TWO"
    return "#{self.class}: INDEX RETURN STRING"
  end

end
