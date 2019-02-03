# frozen_string_literal: true

module Domain
  autoload :Customer, 'domain/customer'
  autoload :RecommendationService, 'domain/recommendation_service'
  autoload :CustomerRepository, 'domain/customer_repository'
  autoload :AcceptanceService, 'domain/acceptance_service'

  InvalidDataError = Class.new(StandardError)
end
