# frozen_string_literal: true
require 'domain'

module Usecase
  # Provides application-level logic for score calculation
  class ScoreCalculator
    # Process given set of events
    # @param events [Array<#customer_name, #extra, #recommendation?, #acceptance?>] collection of events
    def process(events)
      events.each do |event|
        case
        when event.recommendation?
          process_recommendation(event)
        when event.acceptance?
          process_acceptance(event)
        else
          raise Domain::InvalidDataError, 'Unknown event'
        end
      end

      customer_repository.all
    end

    private

    def process_recommendation(recommendation)
      customer = customer_repository.find_by_name(recommendation.customer_name)

      # because of task-specific limitation.
      unless customer
        customer = Domain::Customer.new(name: recommendation.customer_name)
        customer_repository.add(customer)
      end

      recommendation_service.recommend(referrer: customer, referred_name: recommendation.extra)
    end

    def process_acceptance(acceptance)
      customer = customer_repository.find_by_name(acceptance.customer_name)

      raise Domain::InvalidDataError, 'Unknown customer' unless customer

      acceptance_service.accept(customer)
    end

    def customer_repository
      @customer_repository ||= Domain::CustomerRepository.new
    end

    def recommendation_service
      @recommendation_service ||= Domain::RecommendationService.new(customer_repository: customer_repository)
    end

    def acceptance_service
      @acceptance_service ||= Domain::AcceptanceService.new
    end
  end
end
