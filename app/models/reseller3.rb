require "rubygems"
require "sequel"
class Reseller3 < ActiveRecord::Base
  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")
  def self.authenticate(login, password)
    @reseller3s = DB[:resellers3]
    @reseller3s.each do |reseller3|
      if reseller3[:login] == login
       if reseller3[:password] == password
       return reseller3
       else
       return nil
       end
      end
    end
    return nil
  end
end