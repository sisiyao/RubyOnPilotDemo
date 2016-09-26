require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    cookie = req.cookies["_rails_lite_app_flash"]
    if cookie
      @now = JSON.parse(cookie)
    else
      @now = {}
    end

    @next = {}
  end

  def [](key)
    @now[key]
  end

  def []=(key, val)
    @now[key] = val
    @next[key] = val
  end

  def store_flash(res)
    cookie_attributes = {
      path: "/",
      value: @next.to_json
    }
    res.set_cookie("_rails_lite_app_flash", cookie_attributes)
  end
end
