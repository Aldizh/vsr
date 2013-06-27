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
    if payment <= 0 
      flash[:error_payment] = "Payment should be great than 0"
      return redirect_to "/users/viewMyResellers"
    end
    @myResellers = DB[:resellers3]
    @id = DB[:resellers3].where(:login => temp_hash["login"]).first[:id]
    @actual_value = DB[:resellers3].where(:id => @id).first[:callsLimit]
    payment_insertion = DB[:resellerspayments].where(:id_reseller => @id)
    payment_insertion.insert(:money => 1, :id_reseller => @id, :data => Time.now(), :type => 1, :description => "", :actual_value => @actual_value)
    
    payment_update = DB[:resellers3].where(:id => @id)
    payment_update.update(:callsLimit => :callsLimit + payment)
    
    flash[:notice_payment] = "Payment successfully added!"
    redirect_to "/users/viewMyResellers"
  end

  def addReseller3
    # go to table tariffreseller and give me the list of id_tariff whose resellerlevel is empty string
    # and then pass it to the view for a drop down selection
    # put the list of the id_tariffs in a variable named @id_tariffs
    reseller_tariffs = DB[:tariffreseller]
    all_tariffs = DB[:tariffsnames]
    user_tariff_ids = []
    all_tariffs.each do |tariff|
      reseller_tariffs.each do |r_tariff|
        if (tariff[:id_tariff] != r_tariff[:id_tariff] and not user_tariff_ids.include?(tariff[:id_tariff]))
          user_tariff_ids.push(tariff[:id_tariff])
        end
      end
    end
    @tariff_names = []
    names = []
    user_tariff_ids.each do |id|
      names.push(DB[:tariffsnames].where(:id_tariff => id))
    end
    names.each do |n|
      @tariff_names.push(n.first[:description]) rescue nil
    end
  end

  def addReseller3Submit
    #to begin with, we are passing only limited fields.

    @login = params[:login] #required
    @password = params[:password] #required
    # consused?
    @type = params[:type] #required
    #we will grap the id_tariff from the drop down list 
    @id_tariff = params[:id_tariff] #required
    @callsLimit = params[:callsLimit] #required
    @clientsLimit = params[:clientsLimit] #required
    #tech_prefix bit confusing. It has four fields within itself, separated by a semicolon in the db table
    @tech_prefix = params[:tech_prefix] #required
    @identifier =   params[:identifier] #required
    
    # we will not pass the following for now
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

    new_reseller = DB[:resellers3]
    new_reseller.insert(:login => @login, :password => @password, :type => @tyoe, :id_tariff => @id_tariff, :callsLimit => @callsLimit,
                        :clientsLimit => @clientsLimit,  :tech_prefix => @tech_prefix, :identifier => @identifier, :Fullname => @Fullname,
                        :Address => @Address, :City => @City, :ZipCode => @ZipCode, :Country => @Country, :Phone => @Phone, :Email => @Email,
                        :TaxID => @TaxID, :type2 => @type2, :language => @language)
  end

  def show
  end

end
