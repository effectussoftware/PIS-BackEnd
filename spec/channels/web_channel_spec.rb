require 'rails_helper'

RSpec.describe WebChannel, type: :channel do
  let!(:user) { create(:user) }
  # Connection is `identified_by :current_user`
  let(:connection) { TestConnection.new(current_user: user) }

  context 'when receiving actions' do
    # Tests relevantes al webchannel. Por ahora no hay
  end

  it 'subscribes correctly' do
    subscribe

    expect(subscription).to be_confirmed
  end
end

# < ApplicationCable::Connection
class TestConnection
  attr_reader :identifiers, :logger

  def initialize(identifiers_hash = {})
    @identifiers = identifiers_hash.keys
    @logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(StringIO.new))

    # This is an equivalent of providing `identified_by :identifier_key`
    # in ActionCable::Connection::Base subclass
    identifiers_hash.each do |identifier, value|
      define_singleton_method(identifier) do
        value
      end
    end
  end

  def transmit(data)
    # Mock
    # puts data
  end
end
