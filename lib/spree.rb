require "spree/version"

require 'spree/order'
require 'spree/line_item'
require 'spree/adjustment'

require 'spree/promotion'
require 'spree/promotion/actions/create_line_item_adjustment'

module Spree
  DATA = {}
  Config = {
    currency_decimal_mark: ".",
    currency_symbol_position: "before",
    currency_sign_before_symbol: true,
    currency_thousands_separator: ",",
    display_currency: false,
    hide_cents: false
  }
end
