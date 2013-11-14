Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :affiliate_codes do
      member do
        get 'tag-report', action: 'tag_report', as: 'tag_report'
        post 'tag-report', action: 'tag_report', as: 'post_tag_report'
        get 'sku-report', action: 'sku_report', as: 'sku_report'
        post 'sku-report', action: 'sku_report', as: 'post_sku_report'
      end
    end
    resources :reports, :only => [:index] do
      collection do
        get :affiliate_source_report
        post :affiliate_source_report
        get :affiliate_tag_report
        post :affiliate_tag_report
      end
    end
  end
end