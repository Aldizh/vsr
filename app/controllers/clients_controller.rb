require "rubygems"
require "sequel"
class ClientsController < ApplicationController  

  def index
    @result = DB[:clientsshared].where(:id_client => session[:current_client_id])
    @calls = DB[:calls].where(:id_client => session[:current_client_id])
    @payments = DB[:payments].where(:id_client => session[:current_client_id])
  end
  
  def viewMyTariff
  	@result = DB[:clientsshared].where(:id_client => session[:current_client_id])
  	id_tariff = -1
    @result.each do |c|
      id_tariff = c[:id_tariff]
    end
  	@tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def show 
  end

end
