require "rubygems"
require "sequel"
class Reseller1 < ActiveResource::Base
  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")
  def self.authenticate(login, password)
    @reseller1s = DB[:resellers1]
    @reseller1s.each do |reseller1|
      if reseller1[:login] == login
       if reseller1[:password] == password
       return reseller1
       else
       return nil
       end
      end
    end
    return nil
  end
end