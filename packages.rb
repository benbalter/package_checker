require 'httpclient'
require 'savon'
require 'dotenv'

class PackageChecker

  attr_accessor :username
  attr_accessor :password

  WSDL = "http://www.buildinglink.com/Services/MobileLinkResident1_3.svc?singleWsdl"

  def initialize(options)
    @username = options[:username]
    @password = options[:password]
  end

  def client
    @client ||= Savon.client do
      namespace_identifier :ser
      env_namespace :soapenv
      convert_request_keys_to :lower_camelcase
      wsdl PackageChecker::WSDL
    end
  end

  def building_id
    authorized_buildings[:building][:id]
  end

  def login_id
    authorized_buildings[:building][:login_id]
  end

  def authorized_buildings
    @authorized_buildings ||= begin
      response = client.call(:get_authorized_buildings, message: { :username => username, :password => password })
      response.body[:get_authorized_buildings_response][:get_authorized_buildings_result][:buildings]
    end
  end

  def message
    {
      :building_id => building_id,
      :username    => username,
      :password    => password,
      :login_id    => login_id,
    }
  end

  def events
    client.call(:get_events, :message => message).body
  end
end

Dotenv.load

checker = PackageChecker.new :username => ENV["BL_USERNAME"], :password => ENV["BL_PASSWORD"]
puts checker.events
