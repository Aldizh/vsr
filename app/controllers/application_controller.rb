class ApplicationController < ActionController::Base
  protect_from_forgery
  DB = Sequel.connect("mysql2://ciaot1_resell:ciaouser@209.200.231.9:3306/voipswitch")
end
