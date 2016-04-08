module ShipFosdick
  class StateMachine
    include Statesman::Machine

    state :unpushed, initial: true
    state :pushing
    state :pushed

    transition from: :unpushed, to: :pushing
    transition from: :pushing, to: :pushed
  end
end
