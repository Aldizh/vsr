require 'net/http'
require 'json'
require 'rest_client'
class Reseller2sController < ApplicationController  

  def index

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller2_login]}"
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

  def payment_history

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller2_login]}"
    @password = "#{session[:password]}"
    client_login = params[:login]
    client_id = params[:id]
    puts "LOGINNNNNNN"
    puts client_login
    puts "IDDDDDD"
    puts client_id

    @data = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getClientPaymentsHistory",
    "params" => {
        "login" => client_login,
        "clientType" => "Reseller",
        "filter" => {
            "dateFrom" => "2013-05-01",
            "dateTo" => "2013-06-06",
            "moneyFrom" => 0,
            "moneyTo" => 20
    },
            "paging" => {
            "pageNumber" => 0,
            "pageSize" => 10,
            "sortColumn" => "date",
            "descending" => true
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

  end

  def viewMyResellers
    @myResellers = DB[:resellers1].where(:idReseller => session[:current_reseller2_id])
    res = params[:resellers2]
    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
    end
  end

  def addPayment

    temp_payment = params[:payment_amount]
    payment_note = params[:payment_note]
    payment = temp_payment.to_f #changed payment to float
    temp_hash = params[:resellers2]
    login = temp_hash["login"] rescue nil


    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller2_login]}"
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
          "description" => payment_note
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


    if @result["error"] 
      flash[:error_payment] = "Payment did not go through. Please try again!"
    else 
      flash[:notice_payment] = "Payment added successfully!"
    end

    redirect_to "/reseller2s/viewMyResellers"

    
  end

  def show
    
  end

end