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
  
  def payment_history

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"
    client_login = params[:login]
    client_id = params[:id]
    session[:client_login] = client_login

    today = Time.new
    date = (today.to_s).split(" ")
    date_to = date[0]
    date_comps = date_to.split("-")
    year = date_comps[0]
    
    @data = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getClientPaymentsHistory",
    "params" => {
        "login" => client_login,
        "clientType" => "Reseller",
        "filter" => {
            "dateFrom" => "#{year}-01-01",
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

  end

  def filteredPaymentHistory
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
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
    puts @result  
    
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

  def viewActiveCalls
    @active_calls = []
    calls = DB[:currentcalls] #cache this so we don't have to query db inside loop
    client_ids = getClientsIDs()
    client_ids.each do |id|
      @active_calls.push(calls.where(:id_client => id))
    end
  end

  def viewMyResellersCDR
    @my_cdr = []
    @client_CDR = []
    total_cdr = DB[:calls] #cache this so we don't have to query db inside loop
    reseller2s_ids = getClientsIDs()
    reseller1s_ids = []

    reseller2s_ids.each do |id|
     @temp = DB[:Resellers1].where(:idReseller => id)
     @temp.each do |e|
      reseller1s_ids.push(e[:id])
     end
    end
    reseller1s_ids.each do |id|
      @my_cdr.push(total_cdr.where(:id_reseller => id))
    end
  end

  def addPayment

    temp_payment = params[:payment_amount]
    payment_note = params[:payment_note]
    payment = temp_payment.to_f #changed payment to float
    temp_hash = params[:resellers3]
    login = temp_hash["login"] rescue nil


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

    redirect_to "/reseller3s/viewMyResellers"

    
  end

  def viewMyTariff
    @result = DB[:resellers3].where(:id => session[:current_reseller3_id])
    id_tariff = -1
    @result.each do |c|
      id_tariff = c[:id_tariff]
    end
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewResellers2Tariff
    id_agent = params[:id_agent] 

    @result = DB[:resellers2].where(:id => id_agent)
    id_tariff = -1
    @result.each do |c|
      id_tariff = c[:id_tariff]
    end
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewSelected
    @cdr = []
    first_letter = params[:first_letter]
    total_cdr = DB[:calls].filter(:caller_id => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    reseller2s_ids = getClientsIDs()
    reseller1s_ids = []

    reseller2s_ids.each do |id|
     @temp = DB[:Resellers1].where(:idReseller => id)
     @temp.each do |e|
      reseller1s_ids.push(e[:id])
     end
    end
    reseller1s_ids.each do |id|
      @cdr.push(total_cdr.where(:id_reseller => id))
    end
  end

  def show
  end


  def getClientsIDs
    reseller2s_ids = []
    my_direct_clients = DB[:Resellers2].where(:idReseller => session[:current_reseller3_id])
    my_direct_clients.each do |c|
      reseller2s_ids.push(c[:id])
    end
    return reseller2s_ids
  end

end
