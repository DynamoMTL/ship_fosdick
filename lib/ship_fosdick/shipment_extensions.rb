module ShipFosdick
  module ShipmentExtensions
    extend ActiveSupport::Concern
    included do
      include Statesman::Adapters::ActiveRecordQueries
      has_many :transitions, class_name: 'ShipFosdick::Transition',  autosave: false

      def fosdick_state_machine
        @fosdick_state_machine ||= ShipFosdick::StateMachine.new(self, transition_class: ShipFosdick::Transition, association_name: :transitionse)
      end

    end
  end
end

# Spree::Shipment.send(:include, ShipFosdick::ShipmentExtensions)
