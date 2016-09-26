require_relative './route'

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(url_pattern, method, controller_class, action_name)
    @routes << Route.new(url_pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :patch, :put, :delete].each do |http_method|
    define_method(http_method) do |url_pattern, controller_class, action_name|
      add_route(url_pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  def run(req, res)
    route = match(req)
    if route
      route.run(req, res)
    else
      res.status = 404
    end
  end
end
