Spree::Admin::ReportsController.class_eval do
  NEW_REPORTS = {
    :affiliate_source_report => { :name => 'Affiliate Source Report', :description => "Reporting for Affiliate terms added to the Order" },
    :affiliate_tag_report => { :name => 'Affiliate Tag Report', :description => "Reporting for Affiliate terms added to the Line Items" }
  }

  def index
    @reports = Spree::Admin::ReportsController::AVAILABLE_REPORTS.merge(NEW_REPORTS)
  end

  def affiliate_source_report
    params[:q] = {} unless params[:q]
    if params[:q][:created_at_gt].blank?
      params[:q][:created_at_gt] = Time.zone.now.beginning_of_month
    else
      params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end
    if params[:q] && !params[:q][:created_at_lt].blank?
      params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
    end

    params[:q][:completed_at_not_null] = '1'
    params[:q][:campaign_source_not_null] = '1'
    @search = Spree::Order.all.ransack(params[:q])
    @orders = @search.result
    @report = {}
    Spree::AffiliateCode.all.each do |affiliate_code|
      @report[affiliate_code.code.to_sym] = {
        :affiliate_code => affiliate_code,
        :number => 0,
        :payable_order_value => 0,
        :commission => 0
      }
    end
    @orders.each do |order|
      next if @report[order.campaign_source.to_sym].blank?
      @report[order.campaign_source.to_sym][:number] += 1
      @report[order.campaign_source.to_sym][:payable_order_value] += order.item_total
      @report[order.campaign_source.to_sym][:commission] += (@report[order.campaign_source.to_sym][:affiliate_code].rate * order.item_total)
    end
  end

  def affiliate_tag_report
    params[:q] = {} unless params[:q]
    if params[:q][:created_at_gt].blank?
      params[:q][:created_at_gt] = Time.zone.now.beginning_of_month
    else
      params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end
    if params[:q] && !params[:q][:created_at_lt].blank?
      params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
    end
    params[:q][:campaign_tag_not_null] = '1'
    @search = Spree::LineItem.all.ransack(params[:q])
    @line_items = @search.result
    @report = {}
    Spree::AffiliateCode.all.each do |affiliate_code|
      @report[affiliate_code.code.to_sym] = {
        :affiliate_code => affiliate_code,
        :number => 0,
        :payable_order_value => 0,
        :commission => 0
      }
    end
    @line_items.each do |line_item|
      next if !line_item.order.complete? or @report[line_item.campaign_tag.to_sym].blank?
      @report[line_item.campaign_tag.to_sym][:number] += 1
      @report[line_item.campaign_tag.to_sym][:payable_order_value] += line_item.price
      @report[line_item.campaign_tag.to_sym][:commission] += (@report[line_item.campaign_tag.to_sym][:affiliate_code].rate * line_item.price)
    end
  end
end
