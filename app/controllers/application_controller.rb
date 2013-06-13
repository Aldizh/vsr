require "rubygems"
require "sequel"
class ApplicationController < ActionController::Base
  protect_from_forgery
  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")
  def addLeadingZero (arg)
    if arg.to_i < 10
      arg = "0" + arg
    end
    return arg
  end
end
