# frozen_string_literal: true
require_relative "../support/money"

module Acme
  module Pricing
    class DeliveryRules
      Tier = Struct.new(:predicate, :cost, keyword_init: true)

      def initialize(tiers)
        @tiers = tiers.map { |t| Tier.new(predicate: t.predicate, cost: Support::Money.to_d(t.cost)) }.freeze
        freeze
      end

      def cost_for(subtotal)
        sub = Support::Money.round(subtotal)
        tier = @tiers.find { |t| t.predicate.call(sub) }
        tier ? Support::Money.round(tier.cost) : 0.to_d
      end
    end
  end
end
