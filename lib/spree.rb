require "spree/version"

require 'spree/adjustment'
require 'spree/country'
require 'spree/line_item'
require 'spree/order'
require 'spree/product'
require 'spree/tax_category'
require 'spree/tax_rate'
require 'spree/variant'
require 'spree/zone'

require 'spree/promotion'
require 'spree/promotion/actions/create_line_item_adjustment'

module Spree
  Data = {}
  Config = {
    currency_decimal_mark: ".",
    currency_symbol_position: "before",
    currency_sign_before_symbol: true,
    currency_thousands_separator: ",",
    display_currency: false,
    hide_cents: false
  }
end
