module ShipFosdick
  class Transition < ActiveRecord::Base
    belongs_to :shipment, class_name: 'Spree::Shipment', inverse_of: :fosdick_transitions
  end
end
