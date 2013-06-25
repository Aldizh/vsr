require 'net/http'
require 'json'
require 'rest_client'
class Reseller1sController < ApplicationController  

  def index
    @total_cost = 0
    @total_revenue = 0
    @calls = []
    @my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    @my_clients.each do |client|
      @calls.push(DB[:calls_costs].where(:id_client => client[:id_client]))
    end
    @calls.each do |call|
      if call.first
        duration = call.first[:duration]

        @client_tariffs = DB[:tariffs].where(:id_tariff => call.first[:id_tariff], :prefix => call.first[:tariff_prefix])
        @client_tariffs.each do |tariff|
          puts cheapestRoute(tariff[:prefix])
          puts tariff[:voice_rate]
          if (tariff[:minimal_value] == 6 and tariff[:resolution] == 6) 
            @total_revenue += (duration*tariff[:voice_rate]/36)
            #@total_revenue += (duration*cheapestRoute(tariff[:prefix])/36)
          else
            @total_revenue += (duration*tariff[:voice_rate]/60)
            #@total_revenue += (duration*cheapestRoute(tariff[:prefix])/60)
          end
        end
         
        @current = DB[:resellers1].where(:id => session[:current_reseller1_id])
        @parent = DB[:resellers2].where(:id => @current.first[:idReseller])
        @reseller_tariffs = DB[:tariffs].where(:id_tariff => @parent.first[:id_tariff], :prefix => call.first[:tariff_prefix])
        @reseller_tariffs.each do |tariff|
          if (tariff[:minimal_value] == 6 and tariff[:resolution] == 6) 
            #@total_cost += (duration*tariff[:voice_rate]/36)
            @total_cost += (duration*cheapestRoute(tariff[:prefix])/36)
          else
            #@total_cost += (duration*tariff[:voice_rate]/60)
            @total_cost += (duration*cheapestRoute(tariff[:prefix])/60)
          end
        end
      end

    end

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
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
    @login = "#{session[:current_reseller1_login]}"
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
        "clientType" => "Retail",
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
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"
    client_login = session[:client_login]

    date = params[:filteredPaymentHistory]
    

    # addLeadingZero is a helper method to add a leading zero for single digit
    # day or month so that we pass the right date formats to the api method - getClientPaymentsHistory

    from_date_day = date["from_date(3i)"].rjust(2, '0')
    puts from_date_day

    from_date_month = date["from_date(2i)"].rjust(2, '0')
    puts from_date_month

    from_date_year = date["from_date(1i)"]
    puts from_date_year

    to_date_day = date["to_date(3i)"].rjust(2, '0')
    puts "hwjhfbejbf"
    puts to_date_day


    to_date_month = date["to_date(2i)"].rjust(2, '0')
    to_date_year = date["to_date(1i)"]

    date_from = "#{from_date_year}-#{from_date_month}-#{from_date_day}"
    date_to = "#{to_date_year}-#{to_date_month}-#{to_date_day}"

    @data = {
    "jsonrpc" => "2.0",
    "id" => 1,
    "method" => "getClientPaymentsHistory",
    "params" => {
        "login" => client_login,
        "clientType" => "Retail",
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

  def viewMyClients
    @myClients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    respond_to do |format|
      format.html
        format.json { render json: @myClients }
    end
  end

  def viewMyClientsCDR
    @my_cdr = []
    total_cdr = DB[:calls] #cache this so we don't have to query db inside loop
    my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    client_ids = getClientsIDs()
    client_ids.each do |id|
      @my_cdr.push(total_cdr.where(:id_client => id))
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
    temp_hash = params[:resellers1]
    login = temp_hash["login"] rescue nil

    @url = "https://209.200.231.9/vsr3/reseller.api"
    @login = "#{session[:current_reseller1_login]}"
    @password = "#{session[:password]}"

    @data = { 
      "jsonrpc" => "2.0", 
      "id" => 1, 
      "method" => "doClientPayment", 
      "params" => { 
        "login" => login, 
        "clientType" => "Retail", 
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

    redirect_to "/reseller1s/viewMyClients"    
  end

  def viewMyTariff
    @result = DB[:resellers1].where(:id => session[:current_reseller1_id])
    id_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)

  end

  def viewClientsTariff
    @result = DB[:clientsshared].where(:id_client => params[:id_client])
    id_tariff = @result.first[:id_tariff]
    @tariff_list = DB[:tariffs].where(:id_tariff => id_tariff)
  end

  def viewSelected
    @cdr = []
    first_letter = params[:first_letter]
    total_cdr = DB[:calls].filter(:caller_id => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    client_ids = getClientsIDs()
    client_ids.each do |id|
      @cdr.push(total_cdr.where(:id_client => id))
    end
  end

  def viewSelectedTariff
    @tariff_list = []
    first_letter = params[:first_letter]
    total_tariff = DB[:tariffs].filter(:description => /^(#{Regexp.quote(first_letter)}|#{Regexp.quote(first_letter.downcase)})/)
    clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    clients.each do |client|
      @tariff_list.push(total_tariff.where(:id_tariff => client[:id_tariff]))
    end
  end

  def show
  end

  def prefix_match (prefix, number)
    i = 1
    temp = ""
    while i < number.size
      temp = number[0..number.size-i]
      if prefix == temp
        return true
      end
      i += 1
    end
    return false
  end

  def getClientsIDs
    my_clients = DB[:clientsshared].where(:id_reseller => session[:current_reseller1_id])
    client_ids = []
    my_clients.each do |c|
      client_ids.push(c[:id_client])
    end
    return client_ids
  end

  #use this method to calculate the cheapest cost call
  def cheapestRoute(prefix)
    # returns voice_rate of cheapest prefix (including all subprefixes)
    return getAllPrefixRates(prefix).min_by {|k, v| v}[1]
  end

  def getAllPrefixRates(prefix)
    # returns a hash of every subprefix of prefix and rates, key=subprefix, value=voice_rate of subprefix (if it exists)
    prefixes = Hash.new
    (1..(prefix.length)).each do |i|
      subprefix = prefix[0, i]
      subprefix_cost = getPrefixCost(subprefix)
      if not subprefix_cost.nil?
        prefixes[subprefix] = subprefix_cost
      end
    end
    return prefixes
  end

  def getPrefixCost(subprefix)
    # returns voice_rate of prefix if it exists in tariffs database, else nil
    return DB[:tariffs].where(:prefix => subprefix).first[:voice_rate]
  end

end
