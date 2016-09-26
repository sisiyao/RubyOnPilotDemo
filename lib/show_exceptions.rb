require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    app.call(env)
  rescue Exception => @e
    res = Rack::Response.new
    res['Content-Type'] = 'text/html'
    res.status = 500
    res.write(render_exception)
    res.finish
  end

  private

  def stacktrace
    @e.backtrace
  end

  def error_message
    @e.message
  end

  def render_exception
    curr_dir = File.expand_path(File.dirname(__FILE__))
    path_to_template = "#{curr_dir}/templates/rescue.html.erb"
    template_code = File.read(path_to_template)
    source_code_lines = source_code(curr_dir)
    erb_contents = ERB.new(template_code).result(binding)
  end

  def source_code(curr_dir)
    backtrace_file_line = File.expand_path(@e.backtrace[0])
    file_dir = /.*\.rb/.match(backtrace_file_line).to_s
    line_num = /\.rb:\d+/.match(backtrace_file_line).to_s[4..-1].to_i
    file_lines = File.readlines(file_dir)[(line_num - 4)..(line_num + 2)]
  end
end
