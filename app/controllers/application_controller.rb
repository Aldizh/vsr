require "rubygems"
require "sequel"
class ApplicationController < ActionController::Base
  protect_from_forgery
  DB = Sequel.connect("mysql2://resell:ciaouser@209.200.231.9:3306/voipswitch")

  def API_request(login, password, url, payload)
    request = RestClient::Request.new(
      method: :post,
      payload: payload,
      url: url,
      user: login,
      password: password,
      headers: { :accept => :json, :content_type => :json}).execute
    return ActiveSupport::JSON.decode(request)
  end

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
  
  def isMultiple(num)
    if num%6 == 0
      return true
    else return false
    end
  end
  @index = 20

end
