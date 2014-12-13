require 'httpclient'
require 'savon'
require 'dotenv'

class PackageChecker

  WSDL = "http://www.buildinglink.com/Services/MobileLinkResident1_3.svc?singleWsdl"

  def username
    ENV["BL_USERNAME"]
  end

  def password
    ENV["BL_PASSWORD"]
  end

  def client
    @client ||= Savon.client do
      namespace_identifier :ser
      env_namespace :soapenv
      convert_request_keys_to :lower_camelcase
      wsdl PackageChecker::WSDL
      if PackageChecker.debug?
        log_level :debug
        log true
        pretty_print_xml true
      end
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

  def self.debug?
    ENV["DEBUG"] == "1"
  end
end

Dotenv.load

checker = PackageChecker.new
puts checker.events
