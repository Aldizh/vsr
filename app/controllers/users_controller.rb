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
    payment_insertion.insert(:money => 1, :id_reseller => @id, :data => Time.now(), :type => 1, :description => "Test insertion", :actual_value => @actual_value)
    
    payment_update = DB[:resellers3].where(:id => @id).prepare
    payment_update.update(:callsLimit => :callsLimit + payment)
    
    flash[:notice] = "Payment successfully added!"
    redirect_to "/reseller3s/viewMyResellers"

  end

  def show
  end


end
