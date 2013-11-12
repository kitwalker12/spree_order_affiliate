Deface::Override.new(:virtual_path => 'spree/admin/shared/_order_tabs',
  :name => 'add_campaign_source_to_order_edit',
  :insert_before => "dt#order_status",
  :text => "
    <dt id='order_campaign_source' style='height: 42px;'>CAMPAIGN:</dt>
    <dd style='height: 42px;'><%= @order.campaign_source %></dd>
  ")