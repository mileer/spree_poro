require "spree/version"
require "virtus"
require "inflecto"
require "redis"
require "active_model/serialization"
require "active_model_serializers"

module Spree

  Data = Hash.new { |hash, key| hash[key] = [] }

  Config = {
    currency_decimal_mark: ".",
    currency_symbol_position: "before",
    currency_sign_before_symbol: true,
    currency_thousands_separator: ",",
    display_currency: false,
    hide_cents: false
  }
end

ActiveSupport.on_load(:active_model_serializers) do
  # Disable for all serializers (except ArraySerializer)
  ActiveModel::Serializer.root = false

  # Disable for ArraySerializer
  ActiveModel::ArraySerializer.root = false
end

require 'spree/tax_category'
require 'spree/adjustment'
require 'spree/country'
require 'spree/line_item'
require 'spree/order'
require 'spree/order_contents'
require 'spree/product'
require 'spree/shipment'
require 'spree/state'
require 'spree/tax_rate'
require 'spree/variant'
require 'spree/zone'

require 'spree/promotion'
require 'spree/promotion_action'
require 'spree/promotion/actions/create_adjustment'
require 'spree/promotion/actions/create_item_adjustments'

require 'spree/promotion/rules/item_total'

require 'spree/promotion_handler/cart'

require 'spree/item_adjustments'

require 'spree/repositories'
require 'spree/serializers'
