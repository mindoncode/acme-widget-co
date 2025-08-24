# frozen_string_literal: true
module Acme
  module Domain
    Product = Struct.new(:code, :name, :price, keyword_init: true) do
      def initialize(**kwargs)
        super
        raise ArgumentError, "code required"  unless code&.strip&.size&.positive?
        raise ArgumentError, "name required"  unless name&.strip&.size&.positive?
        raise ArgumentError, "price required" unless price
        self.code  = code.strip.upcase.freeze
        self.name  = name.strip.freeze
        self.price = price.is_a?(BigDecimal) ? price : price.to_s.to_d
        freeze
      end
    end
  end
end
