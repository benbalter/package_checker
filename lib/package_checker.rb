require 'httpclient'
require 'savon'
require_relative "package_checker/package"
require_relative "package_checker/building"

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
    @authorized_buildings ||= get(:authorized_buildings, {
      :username => username, :password => password
    })[:buildings]
  end

  def message
    {
      :building_id => building_id,
      :username    => username,
      :password    => password,
      :login_id    => login_id,
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

  private

  def get(endpoint, message = message)
    response = client.call("get_#{endpoint}".to_sym, :message => message)
    response.body["get_#{endpoint}_response".to_sym]["get_#{endpoint}_result".to_sym]
  end
end
