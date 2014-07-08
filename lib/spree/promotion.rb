module Spree
  class Promotion
    attr_accessor :code, :actions, :name, :rules

    def initialize
      self.actions = []
      self.rules = []
    end

    def activate(payload)
      self.actions.each { |a| a.run(payload[:order]) }
    end

    def eligible?(item)
      rules.all? { |r| r.eligible?(item) }
    end
  end
end