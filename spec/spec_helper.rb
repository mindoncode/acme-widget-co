# frozen_string_literal: true
require "rspec"
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "acme"
require "acme/pricing/offers/buy_one_get_second_half"
RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed
end
