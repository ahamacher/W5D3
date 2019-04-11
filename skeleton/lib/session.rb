require 'json'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_rails_lite_app'].nil?
      @session_cookie = {}
    else
      @session_cookie = JSON.parse(req.cookies['_rails_lite_app'])
    end
    # debugger
  end

  def [](key)
    @session_cookie[key]
  end

  def []=(key, val)
    @session_cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    # debugger
    res.set_cookie('_rails_lite_app',{path: '/', value: @session_cookie.to_json})
    # res.set_cookie_header=('_rails_lite_app')
  end
end
