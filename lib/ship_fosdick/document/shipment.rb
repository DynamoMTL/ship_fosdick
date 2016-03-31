require 'nokogiri'

module ShipFosdick
  module Document
    class Shipment
      def initialize(shipment)
        @shipment = shipment
        @config = ShipFosdick.configuration.config
      end

      def to_xml
       fosdick_shipment = ::Nokogiri::XML::Builder.new do |xml|
         xml.UnitycartOrderPost('xml:lang' => 'en-US') {
           xml.ClientCode(config[:client_code])
           xml.Test('Y') if config[:test_mode]
           xml.TransactionID(SecureRandom.hex(15))
           xml.Order {
             build_order_info(xml)
             build_shipping_info(xml)
             build_shipped_items(xml)
           }
         }
       end
       fosdick_shipment.to_xml
      end

      private

      attr_reader :shipment, :config

      def build_order_info(xml)
        xml.ShippingMethod(shipment.shipping_method.admin_name)
        xml.Subtotal(0)
        xml.Total(0)
        xml.ExternalID(shipment.number)
        xml.AdCode(shipment.try(:adcode) || config[:adcode])
        xml.Prepaid('Y')
      end

      def build_shipping_info(xml)
        xml.ShipFirstname(shipping_address.firstname)
        xml.ShipLastname(shipping_address.lastname)
        xml.ShipAddress1(address1)
        xml.ShipAddress2(address2)
        build_state_node(xml)
        xml.ShipCity(format_city)
        xml.ShipZip(shipping_address.zipcode)
        xml.ShipCountry(shipping_address.country.name)
        xml.ShipPhone(shipping_address.phone)
        xml.Email(order.email)
        xml.Code(shipment.shipping_method.id)
      end

      def build_shipped_items(xml)
        shipment.inventory_units.each do |item|
          xml.Items {
            xml.Item {
              xml.Inv(item.variant_id)
              xml.Qty(item.line_item.quantity)
              xml.PricePer(0)
            }
          }
        end
      end

      def build_state_node(xml)
        return xml.ShipStateOther(ship_state) if shipping_address.country.iso3 != 'USA'
        xml.ShipState(ship_state)
      end

      def ship_state
        return '' if !shipping_address.state
        case shipping_address.state.name
        when 'U.S. Armed Forces – Americas' then 'AA'
        when 'U.S. Armed Forces – Europe' then 'AE'
        when 'U.S. Armed Forces – Pacific' then 'AP'
        else
          shipping_address.state.abbr
        end
      end

      def format_city
        return shipping_address.city if shipping_address.city.length < 12
        shipping_address.city.slice(0..12)
      end

      def order
        shipment.order
      end

      def shipping_address
        order.shipping_address
      end

      def address1
        return shipping_address.address1 unless overlong_address
        shipping_address.address1.dup.slice(0, address_max_length).strip
      end

      def address2
        return shipping_address.address2 unless overlong_address
        str = shipping_address.address1.dup
        _, address1_fragment = str.slice!(0, address_max_length), str
        [
          address1_fragment,
          shipping_address.address2,
        ].reject(&:blank?).join(', ').strip.slice(0, address_max_length)
      end

      def overlong_address
        shipping_address.address1.length > address_max_length
      end

      def address_max_length
        @config[:address_max_length]
      end
      
    end
  end
end
