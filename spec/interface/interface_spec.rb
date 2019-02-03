# frozen_string_literal: true

require 'interface'
require 'domain'

describe Interface do
  describe '.build_event_dto' do
    specify do
      expect(described_class.build_event_dto('2018-06-12 09:41 A recommends B')).to eq(Interface::EventDTO.new('A', 'recommends', 'B'))
      expect(described_class.build_event_dto('2018-06-14 09:41 B accepts')).to eq(Interface::EventDTO.new('B', 'accepts'))
    end
  end

  describe '.customers_scores_representation' do
    specify do
      customers = [
        instance_double(Domain::Customer, reward: 30.0, name: 'Foo'),
        instance_double(Domain::Customer, reward: 42.0, name: 'Bar'),
        instance_double(Domain::Customer, reward: 0.0, name: 'Baz')
      ]

      expect(described_class.customers_scores_representation(customers)).to eq('Foo' => 30, 'Bar' => 42, 'Baz' => 0)
    end
  end
end
