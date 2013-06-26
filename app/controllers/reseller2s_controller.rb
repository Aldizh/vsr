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

    @result = API_request(@login, @password, @url, @data)

  end

  def payment_history

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller2_login]}"
    @password = "#{session[:password]}"
    client_login = params[:login]
    client_id = params[:id]
    session[:client_login] = client_login

    today = Time.new
    date_to = (today.to_s).split(" ")[0]
    year = today.year.to_s

    @data = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getClientPaymentsHistory",
    "params" => {
        "login" => client_login,
        "clientType" => "Reseller",
        "filter" => {
            "dateFrom" => "#{year}-05-01",
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

    
    @result = API_request(@login, @password, @url, @data)

  end

      
  def filteredPaymentHistory
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller2_login]}"
    @password = "#{session[:password]}"
    client_login = session[:client_login]

    date = params[:filteredPaymentHistory]

    date_from = Time.new(date["from_date(1i)"], date["from_date(2i)"], date["from_date(3i)"]).strftime("%Y-%m-%d")
    date_to = Time.new(date["to_date(1i)"], date["to_date(2i)"], date["to_date(3i)"]).strftime("%Y-%m-%d")
    
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

    @result = API_request(@login, @password, @url, @data)
    
  end    

  def viewMyResellers
    @myResellers = DB[:resellers1].where(:idReseller => session[:current_reseller2_id])
    respond_to do |format|
      format.html
        format.json { render json: @myResellers }
    end
  end

  def viewMyResellersCDR
    @my_cdr = []
    total_cdr = DB[:calls] #cache this so we don't have to query db inside loop
    client_ids = getClientsIDs()
    client_ids.each do |id|
      @my_cdr.push(total_cdr.where(:id_reseller => id))
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

    @result = API_request(@login, @password, @url, @data)


    if @result["error"] 
      flash[:error_payment] = "Payment did not go through. Please try again!"
    else 
      flash[:notice_payment] = "Payment added successfully!"
    end

    redirect_to "/reseller2s/viewMyResellers"
    
  end

  def viewMyTariff
    @result = DB[:resellers2].where(:id => session[:current_reseller2_id])
    id_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewResellers1Tariff
    id_agent = params[:id_agent] 

    @result = DB[:resellers1].where(:id => id_agent)
    if_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewSelected
    @cdr = []
    first_letter = params[:first_letter]
    total_cdr = DB[:calls].filter(:caller_id => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    client_ids = getClientsIDs()
    client_ids.each do |id|
      @cdr.push(total_cdr.where(:id_reseller => id))
    end
  end

  def viewSelectedTariff
    @tariff_list = []
    first_letter = params[:first_letter]
    total_tariff = DB[:tariffs].filter(:description => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    clients = DB[:resellers1].where(:idReseller => session[:current_reseller2_id])
    clients.each do |client|
      @tariff_list.push(total_tariff.where(:id_tariff => client[:id_tariff]))
    end
  end

  def show
  end
  

  def getClientsIDs
    my_direct_clients = DB[:Resellers1].where(:idReseller => session[:current_reseller2_id])
    client_ids = []
    my_direct_clients.each do |c|
      client_ids.push(c[:id])
    end
    return client_ids
  end

end