class PackageChecker
  class Building

    def initialize(client)
      @client = client
      @meta = client.get(:authorized_buildings, {
        :username => client.username,
        :password => client.password
      })[:buildings][:building]
    end

    def id
      @meta[:id]
    end

    def login_id
      @meta[:login_id]
    end
  end
end
