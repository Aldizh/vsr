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

    @result = API_request(@login, @password, @url, @data)

  end
  
  def payment_history

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
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

    @result = API_request(@login, @password, @url, @data)

  end

  def filteredPaymentHistory
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
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
    
    if payment <= 0 
      flash[:error_payment] = "Payment should be great than 0"
      return redirect_to "/reseller3s/viewMyResellers"
    end

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

    @result = API_request(@login, @password, @url, @data)


    if @result["error"] 
      flash[:error_payment] = "Payment did not go through. Please try again!"
    else 
      flash[:notice_payment] = "Payment added successfully!"
    end

    redirect_to "/reseller3s/viewMyResellers"

  end

  def addReseller2
    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller3_login]}"
    @password = "#{session[:password]}"

    @data = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "arrayOfTariffs",
      "params" => {}
      }.to_json

      @result = API_request(@login, @password, @url, @data)
    
  end

  def addReseller2Submit

    @login = params[:login] #required
    @password = params[:password] #required
    # consused?
    @type = params[:type] #required
    #we will grap the id_tariff from the drop down list 
    temp_hash = params[:reseller2]
    @id_tariff = DB[:tariffsnames].where(:description => temp_hash["description"]).first[:id_tariff] rescue nil
    if @id_tariff == nil     
      @id_tariff = DB[:resellers3].where(:id => session[:current_reseller3_id]).first[:id_tariff]
    end
    @callsLimit = params[:callsLimit] #required
    @clientsLimit = params[:clientsLimit] #required
    @tech_prefix = params[:tech_prefix] #required
    @identifier =   params[:identifier] #required
    
    @Fullname = params[:Fullname] 
    @Address = params[:Address] 
    @City = params[:City] 
    @ZipCode = params[:ZipCode] #required
    @Country = params[:Country] 
    @Phone = params[:Phone] 
    @Email = params[:Email] 
    @TaxID = params[:TaxID]  
    @type2 = params[:type2] #required 
    @language = params[:language] 

    new_reseller = DB[:resellers2]
    new_reseller.insert(:login => @login, :password => @password, :type => @tyoe, :id_tariff => @id_tariff, :callsLimit => @callsLimit,
                        :clientsLimit => @clientsLimit,  :tech_prefix => @tech_prefix, :identifier => @identifier, :Fullname => @Fullname,
                        :Address => @Address, :City => @City, :ZipCode => @ZipCode, :Country => @Country, :Phone => @Phone, :Email => @Email,
                        :TaxID => @TaxID, :type2 => @type2, :language => @language, :type => @type, :idReseller => session[:current_reseller3_id])
    
  end

  def viewMyTariff
    @result = DB[:resellers3].where(:id => session[:current_reseller3_id])
    id_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewResellers2Tariff
    id_agent = params[:id_agent] 

    @result = DB[:resellers2].where(:id => id_agent)
    id_tariff = @result.first[:id_tariff]
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

  def viewSelectedTariff
    @tariff_list = []
    first_letter = params[:first_letter]
    total_tariff = DB[:tariffs].filter(:description => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    clients = DB[:resellers2].where(:idReseller => session[:current_reseller3_id])
    clients.each do |client|
      @tariff_list.push(total_tariff.where(:id_tariff => client[:id_tariff]))
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
