# frozen_string_literal: true

require 'domain'

describe Domain::CustomerRepository do
  specify do
    repository = described_class.new
    customer1 = Domain::Customer.new(name: 'Foo')
    customer2 = Domain::Customer.new(name: 'Bar')
    customer3 = Domain::Customer.new(name: 'Baz')

    repository.add(customer1)
    repository.add(customer2)
    repository.add(customer3)

    expect(repository.find_by_name('Foo')).to eq customer1
    expect(repository.find_by_name('Bar')).to eq customer2
    expect(repository.find_by_name('Baz')).to eq customer3

    expect(repository.all).to match_array([customer1, customer2, customer3])
  end
end
