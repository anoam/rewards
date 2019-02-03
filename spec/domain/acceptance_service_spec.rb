# frozen_string_literal: true
require 'domain'

describe Domain::AcceptanceService do

  describe 'accept' do
    let(:service) { described_class.new }
    specify do
      referrer = Domain::Customer.new(name: 'referrer')
      referred = Domain::Customer.new(name: 'referred', accepted: true)
      referred.referrer = referrer

      expect(referrer).not_to receive(:receive_reward)
      expect(referred).not_to receive(:accept)

      service.accept(referred)
    end

    specify do
      referrer = Domain::Customer.new(name: 'referrer')
      referred = Domain::Customer.new(name: 'referred', accepted: false)

      expect(referrer).not_to receive(:receive_reward)
      expect(referred).to receive(:accept)

      service.accept(referred)
    end

    specify do
      referrer = Domain::Customer.new(name: 'referrer')
      referred = Domain::Customer.new(name: 'referred', accepted: false)
      referred.referrer = referrer

      expect(referrer).to receive(:receive_reward).with(1.0)
      expect(referred).to receive(:accept)

      service.accept(referred)
    end

    specify do
      referrer1 = Domain::Customer.new(name: 'referrer1')
      referrer2 = Domain::Customer.new(name: 'referrer2')
      referrer3 = Domain::Customer.new(name: 'referrer3')
      referred = Domain::Customer.new(name: 'referred', accepted: false)

      referred.referrer = referrer1
      referrer1.referrer = referrer2
      referrer2.referrer = referrer3

      expect(referrer1).to receive(:receive_reward).with(1.0)
      expect(referrer2).to receive(:receive_reward).with(0.5)
      expect(referrer3).to receive(:receive_reward).with(0.25)
      expect(referred).to receive(:accept)

      service.accept(referred)
    end
  end
end
