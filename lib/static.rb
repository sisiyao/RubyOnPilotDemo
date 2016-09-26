class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new

    if /^\/stylesheets(\/\w+)*\/\w+(\.css$)/.match(req.path)
      curr_dir = File.expand_path(File.dirname(__FILE__))
      path_to_asset = "#{curr_dir}/../app#{req.path}"

      if File.exists?(path_to_asset)
        file = File.read(path_to_asset)
        res['Content-type'] = 'text/css'
        res.write(file)
        res.finish
      else
        res.status = 404
        res.write("File not found")
        res.finish
      end
    else
      app.call(env)
    end
  end
end
