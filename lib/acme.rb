# frozen_string_literal: true
require_relative "acme/version"
require_relative "acme/support/money"
require_relative "acme/support/errors"
require_relative "acme/domain/product"
require_relative "acme/domain/catalogue"
require_relative "acme/pricing/delivery_rules"
require_relative "acme/basket"

module Acme
  # Public API re-exports
  Money      = Support::Money
  UnknownProductCode = Support::UnknownProductCode
end
