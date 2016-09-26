require 'json'

class Session
  def initialize(req)
    cookie = req.cookies["_rails_lite_app"]

    if cookie
      @session = JSON.parse(cookie)
    else
      @session = {}
    end
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    cookie_attributes = {
      path: "/",
      value: @session.to_json
    }
    res.set_cookie("_rails_lite_app", cookie_attributes)
  end
end
