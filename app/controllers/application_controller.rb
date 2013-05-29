require "rubygems"
require "sequel"
class ApplicationController < ActionController::Base
  protect_from_forgery

  DB = Sequel.connect("mysql2://ciaot1_resell:ciaouser@209.200.231.164:3306/ciaot1_voipswitch")

end
