class PackageChecker
  class Package

    attr_accessor :tracking_number
    attr_accessor :delivered

    def initialize(hash)
      @tracking_number = hash[:open_comment]
      @delivered       = hash[:open_date]
    end

    def carrier
      PackageChecker::Carrier.find_by_tracking_number(tracking_number)
    end

    def tracking_info
      @tracking_info ||= carrier.find_tracking_info(tracking_number)
    end

    def shipper
      tracking_info.shipment_events.first.location
    end
  end
end
