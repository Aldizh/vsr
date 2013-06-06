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
    session[:client_login] = client_login


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

      
  def filteredPaymentHistory
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller2_login]}"
    @password = "#{session[:password]}"
    client_login = session[:client_login]

    date = params[:filteredPaymentHistory]
    

    # addLeadingZero is a helper method to add a leading zero for single digit
    # day or month so that we pass the right date formats to the api method - getClientPaymentsHistory

    from_date_day = date["from_date(3i)"]
    from_date_day = addLeadingZero(from_date_day)

    from_date_month = date["from_date(2i)"]
    from_date_month = addLeadingZero(from_date_month)

    from_date_year = date["from_date(1i)"]

    to_date_day = date["to_date(3i)"]
    to_date_day = addLeadingZero(to_date_day)

    to_date_month = date["to_date(2i)"]
    to_date_month = addLeadingZero(to_date_month)

    to_date_year = date["to_date(1i)"]

    date_from = "#{from_date_year}-#{from_date_month}-#{from_date_day}"
    date_to = "#{to_date_year}-#{to_date_month}-#{to_date_day}"

    @data = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getClientPaymentsHistory",
    "params" => {
        "login" => client_login,
        "clientType" => "Reseller",
        "filter" => {
            "dateFrom" => date_from,
            "dateTo" => date_to,
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
    puts "RESULLTTTTTTUTUTUTIU"
    puts @result
    
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
  
  def addLeadingZero (arg)
    if arg.to_i < 10
      arg = "0" + arg
      return arg
    end
  end

end