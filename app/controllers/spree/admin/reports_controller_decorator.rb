Spree::Admin::ReportsController.class_eval do
  NEW_REPORTS = {
    :affiliate_source_report => { :name => 'Affiliate Source Report', :description => "Reporting for Affiliate terms added to the Order" },
    :affiliate_tag_report => { :name => 'Affiliate Tag Report', :description => "Reporting for Affiliate terms added to the Line Items" }
  }

  def index
    @reports = AVAILABLE_REPORTS.merge(NEW_REPORTS)
  end

  def affiliate_source_report
    params[:q] ||= {}
    params[:q][:completed_at_not_null] ||= '1'
    @show_only_completed = true
    params[:q][:s] ||= 'completed_at desc'
    created_at_gt = params[:q][:created_at_gt]
    created_at_lt = params[:q][:created_at_lt]
    if !params[:q][:created_at_gt].blank?
      params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
    end

    if !params[:q][:created_at_lt].blank?
      params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
    end

    if @show_only_completed
      params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
      params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
    end
    @search = Spree::Order.accessible_by(current_ability, :index).ransack(params[:q])
    @orders = @search.result.includes([:user, :shipments, :payments]).
      page(params[:page]).
      per(params[:per_page] || 20)
  end

  def affiliate_tag_report
  end
end
