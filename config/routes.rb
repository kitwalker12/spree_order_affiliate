Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :affiliate_codes
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