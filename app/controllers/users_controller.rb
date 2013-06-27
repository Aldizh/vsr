require 'net/http'
require 'json'
require 'rest_client'
class UsersController < ApplicationController  

  def index

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_user_login]}"
    @password = "#{session[:password]}"

    @data = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "getMyDetails",
      "params" => {}
    }.to_json

    @result = API_request(@login, @password, @url, @data)
  end
  
  def viewMyResellers
    @myResellers = DB[:resellers3]
    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
    end
  end

  def addPayment

    temp_payment = params[:payment_amount]
    payment_note = params[:payment_note]
    payment = temp_payment.to_f #changed payment to float
    temp_hash = params[:resellers3]
    @myResellers = DB[:resellers3]
    @id = DB[:resellers3].where(:login => temp_hash["login"]).first[:id]
    @actual_value = DB[:resellers3].where(:id => @id).first[:callsLimit]
    payment_insertion = DB[:resellerspayments].where(:id_reseller => @id).prepare
    payment_insertion.insert(:money => 1, :id_reseller => @id, :data => Time.now(), :type => 1, :description => "", :actual_value => @actual_value)
    
    payment_update = DB[:resellers3].where(:id => @id).prepare
    payment_update.update(:callsLimit => :callsLimit + payment)
    
    flash[:notice] = "Payment successfully added!"
    redirect_to "/reseller3s/viewMyResellers"
  end

  def addReseller
  end
  def addResellerSubmit
    @login = params[:login] #required
    @password = params[:password] #required
    @type = params[:type] #required
    @id_tariff = params[:id_tariff] #required
    @callsLimit = params[:callsLimit] #required
    @clientsLimit = params[:clientsLimit] #required
    @tech_prefix = params[:tech_prefix] #required
    @identifier =   params[:identifier] #required
    @Fullname = params[:Fullname] #required
    @Address = params[:Address] #required
    @City = params[:City] #required
    @ZipCode = params[:ZipCode] #required
    @Country = params[:Country] #required
    @Phone = params[:Phone] #required
    @Email = params[:Email] #required
    @TaxID = params[:TaxID] #required 
    @type2 = params[:type2] #required 
    @language = params[:language] #required
    new_reseller = DB[:resellers3].prepare
    new_reseller.insert(:login => @login, :password => @password, :type => @tyoe, :id_tariff => @id_tariff, :callsLimit => @callsLimit,
                        :clientsLimit => @clientsLimit,  :tech_prefix => @tech_prefix, :identifier => @identifier, :Fullname => @Fullname,
                        :Address => @Address, :City => @City, :ZipCode => @ZipCode, :Country => @Country, :Phone => @Phone, :Email => @Email,
                        :TaxID => @TaxID, :type2 => @type2, :language => @language)
  end

  def show
  end

end
