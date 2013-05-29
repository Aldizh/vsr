require 'net/http'
require 'json'
require 'rest_client'
class Reseller2sController < ApplicationController  

def index
end

def show
	@reseller2 = Reseller2.find(params[:id])
end

end