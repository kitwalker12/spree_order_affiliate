class CreateSpreeAffiliateCodes < ActiveRecord::Migration
  def change
    create_table :spree_affiliate_codes do |t|
      t.string :code
      t.decimal :rate, :precision => 8, :scale => 2
    end
  end
end
