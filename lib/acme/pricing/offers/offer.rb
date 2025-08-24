# frozen_string_literal: true
module Acme
  module Pricing
    module Offers
      class Offer
        def discount(_line_items, _price_of:)
          0.to_d
        end
      end
    end
  end
end
