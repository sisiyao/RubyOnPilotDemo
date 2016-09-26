require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params, :protect

  def initialize(req, res, route_params = {})
    @params = req.params.merge(route_params)
    @req = req
    @res = res
    @already_built_response = false
    @@protect ||= false
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "double render error" if already_built_response?
    @res['Location'] = url
    @res.status = 302
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  def render_content(content, content_type)
    raise "double render error" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    curr_dir = File.expand_path(File.dirname(__FILE__))
    path_to_template = "#{curr_dir}/../app/views/#{controller_name}/#{template_name}.html.erb"

    template_code = File.read(path_to_template)
    erb_contents = ERB.new(template_code).result(binding)

    render_content(erb_contents, 'text/html')
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def invoke_action(action_name)
    if @req.request_method != 'GET' && @@protect == true
      check_authenticity_token
    else
      form_authenticity_token
    end

    self.send(action_name.to_sym)
    unless already_built_response?
      render(action_name)
    end
  end

  def form_authenticity_token
    @token ||= SecureRandom.urlsafe_base64(32)
    @res.set_cookie('authenticity_token', value: @token, path: '/')
    @token
  end

  def check_authenticity_token
    cookie = @req.cookies["authenticity_token"]
    unless cookie && cookie == @params["authenticity_token"]
      raise "Invalid authenticity token"
    end
  end

  def self.protect_from_forgery
    @@protect = true
  end
end
