# auto generate controllers for each collection
# provide skeleton for each rest method with request info returned for testing

rest_root = "\'#{TestRestRoot}\'"

TestRestCollections.each do |collection|
  coll_str = "\'#{collection}\'"
  coll_controller = <<HERE
class TestRest#{collection.to_s.capitalize}Controller < Controller
  map #{rest_root} + #{coll_str}

  def initialize
    @title = "Test Rest"
  end

  def list
    return "{method: \#{action.method}; path_info: \#{request.path_info}; fullpath: \#{request.fullpath};}"
  end

  def create
    response.status = 201
    return "{method: \#{action.method}; path_info: \#{request.path_info}; fullpath: \#{request.fullpath};}"
  end

  def new
    return "{method: \#{action.method}; path_info: \#{request.path_info}; fullpath: \#{request.fullpath};}"
  end

  def show(id)
    return "{method: \#{action.method}; id: \#{id}; path_info: \#{request.path_info}; fullpath: \#{request.fullpath};}"
  end

  def edit(id)
    return "{method: \#{action.method}; id: \#{id}; path_info: \#{request.path_info}; fullpath: \#{request.fullpath};}"
  end

  def update(id)
    return "{method: \#{action.method}; id: \#{id}; path_info: \#{request.path_info}; fullpath: \#{request.fullpath};}"
  end

  def delete(id)
    return "{method: \#{action.method}; id: \#{id}; path_info: \#{request.path_info}; fullpath: \#{request.fullpath};}"
  end
end
HERE

  Ramaze::Log.debug "Test Rest Collection Controller: #{coll_controller}"
  eval coll_controller
end
