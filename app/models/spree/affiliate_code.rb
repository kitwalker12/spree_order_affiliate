module Spree
  class AffiliateCode < ActiveRecord::Base
    validates :code, presence: true, uniqueness: true
    validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  end
end