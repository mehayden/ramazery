# Define REST Routes
# This is based on the URL formats defined at:
# http://microformats.org/wiki/rest/urls
#

module Routes
  module Rest

  # general dispatching patterns
  # Each entry is of the form:
  # [EFFECTIVE_HTTP_METHOD, type] => action
  RestDispatch = {
    [:GET, :collection] => :list,
    [:POST, :collection] => :create,
    [:GET, :collection_new] => :new,
    [:GET, :item] => :show,
    [:PUT, :item] => :update,
    [:DELETE, :item] => :delete,
    [:GET, :item_edit] => :edit
  }

  # hidden field method substitution
  # Each entry is of the form:
  # [HTTP_METHOD, HIDDEN_METHOD] => EFFECTIVE_HTTP_METHOD
  DispatchMethod = {
    [:POST, :PUT] => :PUT,
    [:POST, :DELETE] => :DELETE,
  }   

  # regular expression for
  # item integer id or id.fmt (e.g. 44.json)
  IdRegexp = /^\d+(\.[:alpha]+)?/

  # Rest route translation
  #
  # This is invoked, for example, like the following:
  #   Ramaze::Route('REST Dispatch') do |path, request|
  #    Routes::Rest.route(path, request, '/rest/db/', RestTables)
  #   end
  # Here RestTables is an array of database table symbols. E.g.
  #   RestTables = [:users, articles]
  # It could also be symbols representing other kinds of collections
  #
  def self.route(path, request, path_prefix, collections)
    # normalize path_prefix to end with a '/'
    if path_prefix[-1] != '/'[0]
      path_prefix = path_prefix + '/'
    end
    # check for the rest prefix, otherwise pass
    if path =~ Regexp.new("^#{path_prefix}*")
      rest_path = $'
    else
      return nil
    end
    # initialize variables and get the rest path components
    table = nil
    item = nil
    method = nil
    rest_comps = rest_path.split('/')

    # check for a rest table name (collection name)
    # in the first rest path component, otherwise pass
    collections.each do |tbl|
      if tbl.to_s == rest_comps[0]
        table = tbl
      end
    end
    return nil unless table

    # determine what type of thing we are referencing
    # if there is only one component it is a :collection
    if rest_comps.size == 1
      thing = :collection
    # if the second and last component is 'new'
    # it is a :collection_new
    elsif rest_comps.size == 2
      if rest_comps[1] == 'new'
        thing = :collection_new
      # handle item integer id or id.fmt
      # e.g. /articles/5 or /users/23.json
      elsif rest_comps[1] =~ IdRegexp
        thing = :item
        item = rest_comps[1]
      end
    elsif rest_comps.size == 3
      # handle id/edit, e.g. /users/23/edit
      if rest_comps[1] =~ IdRegexp
        item = rest_comps[1]
        if rest_comps[2] == 'edit'
          thing = :item_edit
        else
          return nil
        end
      else
        return nil
      end
    else
      # following relationships not supported (yet)
      return nil	# for now until more patterns?
    end

    rm = request.request_method.upcase.to_sym
    # check for hidden method parameter
    pm = request.params['_method']
    if pm
       # use the dispatch table if there is a hidden method
       method = DispatchMethod[[rm, pm.to_sym]]
       if method.nil?
         Ramaze::Log.warn "#{self.name}.route: no DispatchMethod for hidden method: #{pm}"
         return nil
       end
    else
      method = rm
    end

    # get the rest action method using the effective method
    action = RestDispatch[[method, thing]]
    return nil unless action

    # construct the destination path in the form of:
    # prefix/collection/action OR
    # prefix/collection/action/id
    new_path = "#{path_prefix}#{table}/#{action}"
    if thing == :item || thing == :item_edit
      new_path << "/#{item}"
    end
    Ramaze::Log.debug "#{self.name}.route: returns: #{new_path}"
    return new_path
  end

  end
end
