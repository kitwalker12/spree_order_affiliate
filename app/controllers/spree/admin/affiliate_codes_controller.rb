module Spree
  module Admin
    class AffiliateCodesController < Spree::Admin::ResourceController

      before_filter :load_affiliate_code, :only => [:update, :edit, :show, :destroy, :tag_report]

      def index
        @affiliate_code = Spree::AffiliateCode.new
        @affiliate_codes = Spree::AffiliateCode.all
      end

      def tag_report
        params[:q] = {} unless params[:q]
        if params[:q][:created_at_gt].blank?
          params[:q][:created_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end
        if params[:q] && !params[:q][:created_at_lt].blank?
          params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
        else
          params[:q][:created_at_lt] = Time.zone.now.end_of_day
        end
        params[:q][:completed_at_not_null] = '1'
        params[:q][:campaign_source_not_null] = '1'

        created_at_gt = params[:q][:created_at_gt].to_date
        created_at_lt = params[:q][:created_at_lt].to_date

        @search = Ransack::Search.new(Spree::Order)
        @report = {}
        @product_sum = 0
        @total = 0
        @commission_sum = 0
        created_at_gt.upto(created_at_lt) { |date|
          line_items = Spree::LineItem.where(created_at: (date.beginning_of_day..date.end_of_day), campaign_tag: @affiliate_code.code)
          @report[date] = {
            :product_sold => 0,
            :payable_order_value => 0,
            :commission => 0
          }
          line_items.each do |line_item|
            next if !line_item.order.complete?
            @report[date][:product_sold] += line_item.quantity
            @product_sum += line_item.quantity
            @report[date][:payable_order_value] += line_item.price
            @total += line_item.price
            @report[date][:commission] += (@affiliate_code.rate * line_item.price)
            @commission_sum += (@affiliate_code.rate * line_item.price)
          end
        }
        @report['Total'] = {
          :product_sold => @product_sum,
          :payable_order_value => @total,
          :commission => @commission_sum
        }
      end

      def show
        params[:q] = {} unless params[:q]
        if params[:q][:created_at_gt].blank?
          params[:q][:created_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end
        if params[:q] && !params[:q][:created_at_lt].blank?
          params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
        else
          params[:q][:created_at_lt] = Time.zone.now.end_of_day
        end
        params[:q][:completed_at_not_null] = '1'
        params[:q][:campaign_source_not_null] = '1'

        created_at_gt = params[:q][:created_at_gt].to_date
        created_at_lt = params[:q][:created_at_lt].to_date

        @search = Ransack::Search.new(Spree::Order)
        @report = {}
        @product_sum = 0
        @total = 0
        @commission_sum = 0
        created_at_gt.upto(created_at_lt) { |date|
          orders = Spree::Order.where(completed_at: (date.beginning_of_day..date.end_of_day), campaign_source: @affiliate_code.code)
          @report[date] = {
            :product_sold => 0,
            :payable_order_value => 0,
            :commission => 0
          }
          orders.each do |order|
            @report[date][:product_sold] += order.item_count
            @product_sum += order.item_count
            @report[date][:payable_order_value] += order.item_total
            @total += order.item_total
            @report[date][:commission] += (@affiliate_code.rate * order.item_total)
            @commission_sum += (@affiliate_code.rate * order.item_total)
          end
        }
        @report['Total'] = {
          :product_sold => @product_sum,
          :payable_order_value => @total,
          :commission => @commission_sum
        }
      end

      private
        def load_affiliate_code
          @affiliate_code = Spree::AffiliateCode.find(params[:id])
        end
    end
  end
end