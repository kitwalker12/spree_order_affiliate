class AddCampaignSourceToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :campaign_source, :string
  end
end
