require 'httparty'
module ShipFosdick
  class Sender
    include HTTParty
    base_uri 'https://www.unitycart.com'
    format :xml

    def self.send_doc(doc)
      client = ShipFosdick.configuration.client_name
      res    = post("/#{client}/cart/ipost.asp", body: doc)
      validate(res)
      return build_success_hash(res['UnitycartOrderResponse']['OrderResponse'])
    end

    private

    def self.build_success_hash(res)
      {
        external_id: res["ExternalID"],
        order_number: res["OrderNumber"]
      }
    end

    def self.validate(res)
      order_res = res['UnitycartOrderResponse']['OrderResponse']

      case
      when order_res.kind_of?(Hash)
        errors = order_res.has_key?('ErrorCode')
      when order_res.kind_of?(Array)
        errors = order_res.first.has_key?('ErrorCode')
      else
        errors = nil
      end

      raise SendError, order_res if errors
    end
  end

  class SendError < StandardError; end
end
