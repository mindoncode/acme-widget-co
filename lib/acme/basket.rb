# frozen_string_literal: true
require_relative "support/money"
require_relative "domain/catalogue"

module Acme
  class Basket
    def initialize(catalogue:, delivery_rules:, offers: [])
      @catalogue      = catalogue
      @delivery_rules = delivery_rules
      @offers         = Array(offers).freeze
      @line_items     = []
    end

    def add(product_code)
      code = normalize_code(product_code)
      @catalogue.fetch!(code)
      @line_items << code
      self
    end

    def total
      subtotal       = sum_prices(@line_items)
      discount_total = total_discount(@line_items)
      discounted     = Support::Money.clamp_non_negative(subtotal - discount_total)
      delivery       = @delivery_rules.cost_for(discounted)
      Support::Money.format(discounted + delivery)
    end

    def items
      @line_items.dup
    end

    private

    def sum_prices(codes)
      codes.reduce(0.to_d) { |acc, code| acc + price_of(code) }
    end

    def price_of(code)
      @catalogue.fetch!(code).price
    end

    def total_discount(codes)
      return 0.to_d if @offers.empty?
      lookup = ->(code) { price_of(code) }
      @offers.reduce(0.to_d) { |acc, offer| acc + offer.discount(codes, price_of: lookup) }
    end

    def normalize_code(code)
      String(code).strip.upcase
    end
  end
end
