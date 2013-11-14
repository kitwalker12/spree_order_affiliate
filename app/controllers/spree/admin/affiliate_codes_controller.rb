module Spree
  module Admin
    class AffiliateCodesController < Spree::Admin::ResourceController

      before_filter :load_affiliate_code, :only => [:update, :edit, :show, :destroy]

      def index
        @affiliate_code = Spree::AffiliateCode.new
        @affiliate_codes = Spree::AffiliateCode.all
      end

      private
        def load_affiliate_code
          @affiliate_code = Spree::AffiliateCode.find(params[:id])
        end
    end
  end
end