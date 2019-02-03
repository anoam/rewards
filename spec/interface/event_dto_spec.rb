# frozen_string_literal: true

require 'interface'

describe Interface::EventDTO do
  specify do
    expect(described_class.new('foo', 'recommends')).to be_recommendation
    expect(described_class.new('foo', 'recommends')).not_to be_acceptance

    expect(described_class.new('bar', 'accepts')).not_to be_recommendation
    expect(described_class.new('bar', 'accepts')).to be_acceptance

    expect(described_class.new('baz', 'unknown')).not_to be_recommendation
    expect(described_class.new('baz', 'unknown')).not_to be_acceptance
  end
end
