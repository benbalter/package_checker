require 'httpclient'
require 'savon'
require 'active_shipping'
require 'dotenv'
require_relative "package_checker/package"
require_relative "package_checker/building"

Dotenv.load
I18n.enforce_available_locales = false

class PackageChecker

  attr_accessor :username
  attr_accessor :password
  attr_accessor :building

  WSDL = "http://www.buildinglink.com/Services/MobileLinkResident1_3.svc?singleWsdl"

  def initialize(options)
    @username = options[:username]
    @password = options[:password]
    @building = Building.new(self)
  end

  def client
    @client ||= Savon.client do
      namespace_identifier :ser
      env_namespace :soapenv
      convert_request_keys_to :lower_camelcase
      wsdl PackageChecker::WSDL
    end
  end

  def message
    {
      :building_id => building.id,
      :username    => username,
      :password    => password,
      :login_id    => building.login_id,
    }
  end

  def packages
    events = get(:events)
    if events.empty?
      []
    else
      [Package.new(events[:event])]
    end
  end

  def get(endpoint, message = message)
    response = client.call("get_#{endpoint}".to_sym, :message => message)
    response.body["get_#{endpoint}_response".to_sym]["get_#{endpoint}_result".to_sym]
  end
end
