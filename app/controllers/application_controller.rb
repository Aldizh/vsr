require "rubygems"
require "sequel"
class ApplicationController < ActionController::Base
  protect_from_forgery
  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")

  def API_request(login, password, url, payload)
    request = RestClient::Request.new(
      method: :post,
      payload: payload,
      url: url,
      user: login,
      password: password,
      headers: { :accept => :json, :content_type => :json}).execute
    return ActiveSupport::JSON.decode(request)
  end

end
