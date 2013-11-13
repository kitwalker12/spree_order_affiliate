Spree::Core::Engine.routes.draw do
  namespace :admin do
    get 'affiliate/reporting', action: 'reporting', controller: 'order_affiliate'
  end
end