class ChargeOrderJob < ApplicationJob
  queue_as :default

  def perform(order, pay_type_params)
    Charger.new(order, pay_type_params).charge!
  end
end
