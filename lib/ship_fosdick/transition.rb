module ShipFosdick
  class Transition
    belongs_to :shipment, class: 'Spree::Shipment', inverse_of: :fosdick_transitions
  end
end
