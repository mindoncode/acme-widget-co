# frozen_string_literal: true
require_relative "../support/errors"

module Acme
  module Domain
    class Catalogue
      def initialize(products)
        @index = {}
        products.each { |p| @index[p.code] = p }
        @index.freeze
        freeze
      end

      def fetch!(code)
        normalized = normalize_code(code)
        @index.fetch(normalized) { raise Support::UnknownProductCode, "Unknown product code: #{code.inspect}" }
      end

      private

      def normalize_code(code)
        String(code).strip.upcase
      end
    end
  end
end
