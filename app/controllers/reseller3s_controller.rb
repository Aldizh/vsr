require 'net/http'
require 'json'
require 'rest_client'
class Reseller3sController < ApplicationController  

  def index

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"

    @data = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "getMyDetails",
      "params" => {}
    }.to_json


    @response = RestClient::Request.new(
      :method => :post,
      :payload => @data,
      :url => @url,
      :user => @login,
      :password => @password,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result = ActiveSupport::JSON.decode(@response)  

  end

  def viewMyResellers
    @myResellers = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    res = params[:resellers3]
    puts res
    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
    end
  end

  def addPayment

    temp_payment = params[:payment_amount]
    payment = temp_payment.to_f #changed payment to float
    #puts "WOOOOOOOOOOOO"
    #puts payment
    temp_hash = params[:resellers3]
    login = temp_hash["login"] rescue nil
    #@myReseller = DB[:resellers2].where(:login => @login)
    #@myReseller.each do |reseller|
      #@type = reseller[:type]
      #puts reseller
    #end


    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"

    @data = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "doClientPayment",
      "params" => {
        "login" => login,
        "clientType" => "Reseller",
        "payment" => {
            "paymentType" => "Payment",
            "amount" => payment,
            "desription" => ""
        }
      }
    }.to_json


    @response = RestClient::Request.new(
      :method => :post,
      :payload => @data,
      :url => @url,
      :user => @login,
      :password => @password,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result = ActiveSupport::JSON.decode(@response) 
    puts "TASHI DELEK!"
    puts @response
    
  end

  def show
    
  end

end
