# frozen_string_literal: true

require 'domain'

describe Domain::Customer do
  describe 'acceptance' do
    specify do
      expect(described_class.new(name: 'Foo')).to be_accepted
      expect(described_class.new(name: 'Foo', accepted: true)).to be_accepted
      expect(described_class.new(name: 'Foo', accepted: false)).not_to be_accepted
    end

    specify do
      customer = described_class.new(name: 'Foo', accepted: false)
      confirmed_customer = described_class.new(name: 'Foo', accepted: true)

      expect { customer.accept }.to change(customer, :accepted?).to(true)
      expect { confirmed_customer.accept }.not_to change(customer, :accepted?)
    end
  end

  describe 'name' do
    specify do
      expect(described_class.new(name: 'Foo').name).to eql 'Foo'
      expect(described_class.new(name: 'bar').name).to eql 'bar'
    end
  end

  describe 'referrer' do
    specify do
      referrer = described_class.new(name: 'Referer')
      referred = described_class.new(name: 'Referred')

      expect { referred.referrer = referrer }.to change(referred, :referrer).from(nil).to(referrer)
    end
  end

  describe 'identity' do
    specify do
      expect(described_class.new(name: 'Foo')).to eql(described_class.new(name: 'Foo'))
      expect(described_class.new(name: 'Foo')).not_to eql(described_class.new(name: 'Bar'))
      expect(described_class.new(name: 'Foo', accepted: true)).to eql(described_class.new(name: 'Foo', accepted: false))
      expect(described_class.new(name: 'Foo')).not_to eql(double(name: 'Foo'))
    end
  end

  describe 'rewards' do
    specify do
      expect(described_class.new(name: 'Foo').reward).to eq 0
      expect(described_class.new(name: 'Foo', reward: 42.0).reward).to eq 42
    end

    specify do
      customer = described_class.new(name: 'Foo', reward: 42.0)
      customer.receive_reward(3)

      expect(customer.reward).to eq 45

      customer.receive_reward(5)
      expect(customer.reward).to eq 50
    end
  end
end
