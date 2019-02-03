# frozen_string_literal: true

module Domain
  # Service that represents the invitation acceptance process
  class AcceptanceService
    # Process the acceptance of invitation by a customer
    # @param customer [Domain::Customer] customer who accepted invitation
    def accept(customer)
      return if customer.accepted?

      customer.accept
      spread_rewards(customer.referrer)
    end

    private

    def spread_rewards(customer)
      reward = base_reward_size
      loop do
        break unless customer

        customer.receive_reward(reward)
        customer = customer.referrer
        reward /= 2
      end
    end

    def base_reward_size
      1.0
    end
  end
end
