# frozen_string_literal: true

# Implements conversion required for user interacting
module Interface
  # This DTO represents event data
  EventDTO = Struct.new(:customer_name, :action_type, :extra) do
    # @return [Boolean] true if the DTO represents a recommendation command
    def recommendation?
      action_type == 'recommends'
    end

    # @return [Boolean] true if the DTO represents a acceptance command
    def acceptance?
      action_type == 'accepts'
    end
  end

  # Builds new event DTO using raw string representation
  # @param raw_parameters [String]
  #   @example
  #     2018-06-12 09:41 A recommends B
  #   @example
  #     2018-06-14 09:41 B accepts
  # @return [Interface::EventDTO] DTO contained parameters
  def self.build_event_dto(raw_parameters)
    params = raw_parameters.split("\s")

    EventDTO.new(*params[2..-1])
  end

  # Transforms array of customers to hash, where keys are names of customers and values are they reward scores
  # @param customers [Array<Domain::Customer>] collection of customers for representation
  def self.customers_scores_representation(customers)
    customers.each_with_object({}) do |customer, memo|
      memo[customer.name] = customer.reward
    end
  end
end
