module Spree
  Api::LineItemsController.class_eval do

    def create
      variant = Spree::Variant.find(params[:line_item][:variant_id])
      @line_item = order.contents.add(variant, params[:line_item][:quantity])
      @line_item.campaign_tag = params[:line_item][:campaign_tag]
      if @line_item.save
        respond_with(@line_item, status: 201, default_template: :show)
      else
        invalid_resource!(@line_item)
      end
    end


    private
      def line_item_params
        params.require(:line_item).permit(:quantity, :variant_id, :campaign_tag)
      end
  end
end