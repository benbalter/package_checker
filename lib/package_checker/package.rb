class PackageChecker
  class Package

    attr_accessor :tracking_number
    attr_accessor :delivered

    def initialize(hash)
      @tracking_number = hash[:open_comment]
      @delivered       = hash[:open_date]
    end

    def carrier
      # source http://stackoverflow.com/a/5024011
      case tracking_number
      when /\b(1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\d\d\d ?\d\d\d\d ?\d\d\d)\b/i
        ActiveMerchant::Shipping::UPS.new({
          :key      => ENV["UPS_KEY"],
          :login    => ENV["UPS_LOGIN"],
          :password => ENV["UPS_PASSWORD"]
        })
      when /(\b96\d{20}\b)|(\b\d{15}\b)|(\b\d{12}\b)/i
        :fedex
      when /\b((98\d\d\d\d\d?\d\d\d\d|98\d\d) ?\d\d\d\d ?\d\d\d\d( ?\d\d\d)?)\b/i
        :fedex
      when /^[0-9]{15}$/i
        :fedex
      when /(\b\d{30}\b)|(\b91\d+\b)|(\b\d{20}\b)/i
        :usps
      when /^E\D{1}\d{9}\D{2}$|^9\d{15,21}$/i
        :usps
      when /^91[0-9]+$/i
        :usps
      when /^[A-Za-z]{2}[0-9]+US$/i
        :usps
      end
    end

    def tracking_info
      @tracking_info ||= carrier.find_tracking_info(tracking_number)
    end

    def shipper
      tracking_info.shipment_events.first.location
    end
  end
end
