class AddCampaignTagToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :campaign_tag, :string
  end
end
