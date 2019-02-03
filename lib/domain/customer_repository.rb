# frozen_string_literal: true
require 'set'

module Domain
  # Abstraction over a collection of [Customer]s
  class CustomerRepository
    def initialize
      @collection = Set.new
    end

    # @param name [String] name of the Customer to find
    # @return [Customer] the customer with given name or nil if the Customer wasn't found
    def find_by_name(name)
      collection.find { |customer| customer.name == name }
    end

    # Adds a customer to the collection
    # @param name [Customer] customer to add into collection
    def add(customer)
      collection.add(customer)
    end

    # @return [Array<Customer>] all stored customers
    def all
      collection.to_a
    end

    private
    attr_reader :collection
  end
end
