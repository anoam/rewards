# frozen_string_literal: true

require 'domain'

describe Domain::RecommendationService do
  describe 'recommend' do
    let(:customer_repository) { instance_double(Domain::CustomerRepository) }
    let(:service) { described_class.new(customer_repository: customer_repository) }

    specify do
      referrer = Domain::Customer.new(name: 'referrer')
      referred = Domain::Customer.new(name: 'referred')

      allow(customer_repository).to receive(:find_by_name).with('referred').and_return(nil)

      expect(customer_repository).to receive(:add).with(referred)
      service.recommend(referrer: referrer, referred_name: 'referred')
    end

    specify do
      referrer = Domain::Customer.new(name: 'referrer')
      referred = Domain::Customer.new(name: 'referred')

      allow(customer_repository).to receive(:find_by_name).with('referred').and_return(referred)

      expect(customer_repository).not_to receive(:add)
      service.recommend(referrer: referrer, referred_name: 'referred')
    end

    specify do
      referrer = Domain::Customer.new(name: 'referrer')

      allow(customer_repository).to receive(:find_by_name).and_return(nil)

      expect { service.recommend(referrer: referrer, referred_name: '') }.to raise_exception(Domain::InvalidDataError)
      expect { service.recommend(referrer: referrer, referred_name: nil) }.to raise_exception(Domain::InvalidDataError)
    end
  end
end
