module ShipFosdick
  module ShipmentExtensions
    extend ActiveSupport::Concern
    included do
      include Statesman::Adapters::ActiveRecordQueries
      has_many :transitions, class: 'ShipFosdick::Transition',  autosave: false

      def fosdick_state_machine
        @fosdick_state_machine ||= ShipFosdick::StateMachine.new(self, transition_class: ShipFosdick::Transition)
      end

      def self.transition_class
        ShipFosdick::Transition
      end
      private_class_method :transition_class

      def self.initial_state
        :unpushed
      end
      private_class_method :initial_state
    end
  end
end

Spree::Shipment.send(:include, ShipFosdick::ShipmentExtensions)
