Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
 :name => "add_affiliates_tab_to_admin_bar",
 :insert_bottom => "[data-hook='admin_tabs']",
 :text => "
    <%= tab :affiliate_reporting, :icon => 'icon-file' %> %>
  "
 )