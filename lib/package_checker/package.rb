class PackageChecker
  class Package

    attr_accessor :carrier
    attr_accessor :tracking_number
    attr_accessor :delivered

    def initialize(hash)
      @carrier         = hash[:type_description_short]
      @tracking_number = hash[:open_comment]
      @delivered       = hash[:open_date]
    end
  end
end
