# frozen_string_literal: true
require_relative "offer"
require_relative "../../support/money"

module Acme
  module Pricing
    module Offers
      class BuyOneGetSecondHalf < Offer
        def initialize(product_code:)
          @code = String(product_code).strip.upcase.freeze
          freeze
        end

        def discount(line_items, price_of:)
          count = line_items.count { |c| c == @code }
          pairs = count / 2
          return 0.to_d if pairs.zero?
          unit = price_of.call(@code)
          Acme::Support::Money.round(pairs * (unit / 2))
        end
      end
    end
  end
end
