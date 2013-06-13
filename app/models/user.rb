require "rubygems"
require "sequel"
class User < ActiveRecord::Base
  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")
  def self.authenticate(login, password)
    @users = DB[:users]
    @users.each do |user|
      if user[:login] == login
       if user[:password] == password
       return user
       else
       return nil
       end
      end
    end
    return nil
  end
end
