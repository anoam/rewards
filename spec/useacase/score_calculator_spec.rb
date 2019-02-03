# frozen_string_literal: true
require 'usecase'

describe Usecase::ScoreCalculator do
  subject(:service) { described_class.new }
  specify do
    customer1 = Domain::Customer.new(name: 'Foo')
    customer2 = Domain::Customer.new(name: 'Fizz')
    unknown_customer = Domain::Customer.new(name: 'Baz')

    allow_any_instance_of(Domain::CustomerRepository).to receive(:find_by_name).with('Foo').and_return(customer1)
    allow_any_instance_of(Domain::CustomerRepository).to receive(:find_by_name).with('Fizz').and_return(customer2)
    allow_any_instance_of(Domain::CustomerRepository).to receive(:find_by_name).with('Baz').and_return(nil)

    events = [
      double(customer_name: 'Foo', recommendation?: true, acceptance?: false, extra: 'Bar'),
      double(customer_name: 'Baz', recommendation?: true, acceptance?: false, extra: 'Buzz'),

      double(customer_name: 'Fizz', recommendation?: false, acceptance?: true)
    ]

    expect_any_instance_of(Domain::RecommendationService).to receive(:recommend).with(referrer: customer1, referred_name: 'Bar')
    expect_any_instance_of(Domain::RecommendationService).to receive(:recommend).with(referrer: unknown_customer, referred_name: 'Buzz')

    expect_any_instance_of(Domain::CustomerRepository).to receive(:add).with(unknown_customer)

    expect_any_instance_of(Domain::AcceptanceService).to receive(:accept).with(customer2)

    service.process(events)
  end

  specify do
    events = [double(customer_name: 'Foo', recommendation?: false, acceptance?: false),]

    expect { service.process(events) }.to raise_exception(Domain::InvalidDataError)
  end

  specify do
    allow_any_instance_of(Domain::CustomerRepository).to receive(:find_by_name).with('Foo').and_return(nil)

    events = [double(customer_name: 'Foo', recommendation?: false, acceptance?: true),]

    expect { service.process(events) }.to raise_exception(Domain::InvalidDataError)
  end
end
