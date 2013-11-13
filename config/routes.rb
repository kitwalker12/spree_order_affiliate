Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :reports, :only => [:index, :show] do
      collection do
        get :affiliate_source_report
        post :affiliate_source_report
        get :affiliate_tag_report
        post :affiliate_tag_report
      end
    end
  end
end