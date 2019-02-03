# frozen_string_literal: true

module Domain
  # Domain entity. Represents a person, who use o can potentially use our service
  class Customer
    # @return [String] identity of the customer
    attr_reader :name
    # @return [Numeric] amount of received rewards
    attr_reader :reward
    # @return [Domain::Customer] a customer who has recommended this one
    attr_accessor :referrer

    # @param name [String] identity of the customer
    # @param accepted [Boolean] flag that shows if the customer has accepted an invitation
    def initialize(name:, accepted: true, reward: 0.0)
      @name = name
      @accepted = accepted
      @reward = reward
    end

    # @return [Boolean] flag that display if the customer has accepted an invitation
    def accepted?
      @accepted
    end

    # Manages the customer to accept an invitation
    def accept
      @accepted = true
    end

    # Increases amount of received wards by `amount`
    # @param amount [Numeric] amount of new reward
    def receive_reward(amount)
      @reward += amount
    end

    # @param other [Domain::Customer] another customer to compare identity
    # @return [Boolean] true if the has the same identity as the given one
    def eql?(other)
      return false unless other.is_a?(Domain::Customer)

      name == other.name
    end
    alias == eql?
  end
end
