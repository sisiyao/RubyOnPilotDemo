class Route
  attr_reader :url_pattern, :http_method, :controller_class, :action_name

  def initialize(url_pattern, http_method, controller_class, action_name)
    @url_pattern = url_pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    if req.params["_method"] && req.params["_method"].downcase == "patch"
      req_method = :patch
    elsif req.params["_method"] && req.params["_method"].downcase == "delete"
      req_method = :delete
    else
      req_method = req.request_method.downcase.to_sym
    end
    self.url_pattern =~ req.path && self.http_method == req_method
  end

  def run(req, res)
    url_regex = Regexp.new(self.url_pattern)
    match_data = url_regex.match(req.path)

    route_params = {}

    match_data.names.each do |name|
      route_params[name] = match_data[name]
    end

    controller = self.controller_class.new(req, res, route_params)
    controller.invoke_action(self.action_name)
  end
end
