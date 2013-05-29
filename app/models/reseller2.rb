require "rubygems"
require "sequel"
class Reseller2 < ActiveResource::Base
  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")
  def self.authenticate(login, password)
    @reseller2s = DB[:resellers2]
    @reseller2s.each do |reseller2|
      if reseller2[:login] == login
       if reseller2[:password] == password
       return reseller2
       else
       return nil
       end
      end
    end
    return nil
  end
end