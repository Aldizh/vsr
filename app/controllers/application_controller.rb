require "rubygems"
require "sequel"
class ApplicationController < ActionController::Base
  protect_from_forgery

  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")

end
