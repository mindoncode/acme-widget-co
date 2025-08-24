# frozen_string_literal: true
require "bigdecimal"
require "bigdecimal/util"

module Acme
  module Support
    module Money
      module_function

      def to_d(num)
        case num
        when BigDecimal then num
        when String     then num.to_d
        when Numeric    then num.to_s.to_d
        else
          raise ArgumentError, "Unsupported money type: #{num.class}"
        end
      end

      def round(amount)
        to_d(amount).round(2, BigDecimal::ROUND_HALF_UP)
      end

      def clamp_non_negative(amount)
        [round(amount), 0.to_d].max
      end

      def format(amount)
        "$%.2f" % round(amount)
      end
    end
  end
end
