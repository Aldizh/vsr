require "rubygems"
require "sequel"
class ClientsController < ApplicationController  

  def index
    @result = DB[:clientsshared].where(:id_client => session[:current_client_id])
    @calls = DB[:calls].where(:id_client => session[:current_client_id])
    @payments = DB[:payments].where(:id_client => session[:current_client_id])
  end
  
  def show 
  end

end
