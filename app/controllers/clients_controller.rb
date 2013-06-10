require 'net/http'
require 'json'
require 'rest_client'
require "rubygems"
require "sequel"
class ClientsController < ApplicationController  

  def index

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_client_login]}"
    @password = "#{session[:password]}"

    @result = DB[:clientsshared].where(:id_client => session[:current_client_id])
    @calls = DB[:calls].where(:id_client => session[:current_client_id])
    @payments = DB[:payments].where(:id_client => session[:current_client_id])

  end
  
  def show 
  end

end
