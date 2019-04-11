require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res 
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise error if already_built_response?
    @res.status = 302
    @res.location = url
    session.store_session(@res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type="text/html")
    raise error if already_built_response?
    @res["Content-Type"] = content_type
    @res.write(content)
    @res.finish
    session.store_session(@res)
    @already_built_response = true
  end
  
  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    dir = File.dirname(__FILE__).split('/')[0...-1].join('/')
    path = File.join(dir, "views", self.class.to_s.underscore, "#{template_name}.html.erb")
    content_erb = File.read(path)
    content = ERB.new(content_erb).result(binding)
    render_content(content)
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

