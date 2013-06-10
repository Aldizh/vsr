require "rubygems"
require "sequel"
class Client < ActiveResource::Base
  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")
  def self.authenticate(login, password)
    @clients = DB[:clientsshared]
    @clients.each do |client|
      if client[:login] == login
       if client[:password] == password
       return client
       else
       return nil
       end
      end
    end
    return nil
  end
end