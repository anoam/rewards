# frozen_string_literal: true
#
module Domain
  # Service that represents recommendation process
  class RecommendationService
    # @param customer_repository [Domain::CustomerRepository] repository of known customers
    def initialize(customer_repository:)
      @repository = customer_repository
    end

    # @param referrer [Domain::Customer] a customer who has invited the new one
    # @param referred_name [String] name of the recommended user
    def recommend(referrer:, referred_name:)
      return if repository.find_by_name(referred_name)

      new_customer = build_referred_customer(referred_name, referrer)
      repository.add(new_customer)
    end

    private
    attr_reader :repository

    def build_referred_customer(name, referrer)
      raise InvalidDataError, 'Invalid customer name' if name.nil? || name.empty?
      new_customer = Customer.new(name: name, accepted: false)
      new_customer.referrer = referrer
      new_customer
    end
  end
end
