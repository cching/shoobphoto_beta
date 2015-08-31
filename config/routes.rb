require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web, at: "/sidekiq"
  

  resources :pages

  resources :student_images

  resources :schools

  resources :items
  match 'emailers/' => 'emailers#index', :via => 'GET', :as => 'emailer'
  match 'emailers/csv' => 'emailers#import', :via => 'POST', :as => 'import_emailer'
  namespace :admin do
    resources :dashboards
    resources :schools
    resources :packages
    resources :pages
    resources :nav_links
    resources :banners

    resources :extra_types

    resources :extras
    
    match 'packages/:id/csv' => 'packages#csv', :via => 'GET', :as => 'csv_packages'
    match 'packages/:id/csv' => 'packages#import', :via => 'POST', :as => 'import_packages'
    match 'packages/:id/email' => 'packages#email_csv', :via => 'GET', :as => 'email_csv'
    match 'packages/:id/email' => 'packages#email_import', :via => 'POST', :as => 'email_import'
    match 'students/' => 'students#index', :via => 'GET', :as => 'students'
    match 'students/csv' => 'students#csv', :via => 'GET', :as => 'csv_students'
    match 'students/csv' => 'students#import', :via => 'POST', :as => 'import_students'
    match 'students/where_empty_by_school' => 'students#where_empty', :via => ['POST', 'GET'], :as => 'where_empty_students'
    match 'pages/:id/csv' => 'pages#csv', :via => 'GET', :as => 'csv_pages'
    match 'pages/csv' => 'pages#import', :via => 'POST', :as => 'import_pages'
    match 'navlinks/csv/' => 'nav_links#csv', :via => 'GET', :as => 'csv_nav_links'
    match 'navlinks/csv' => 'nav_links#import', :via => 'POST', :as => 'import_nav_links'
  end

  devise_for :users, :except => [:sign_up]
  match 'students' => 'students#schools', :via => 'GET', :as => 'student_schools'
  match 'students/cart/:id' => 'students#cart', :via => 'GET', :as => 'student_cart'
  match 'students/duplicate/:school' => 'students#duplicate', :via => 'GET', :as => 'student_duplicate'
  match 'students/input/:school/:cart/:i' => 'students#input', :via => 'GET', :as => 'student_input'
  match 'students/school_find/' => 'students#school_find', :via => 'GET', :as => 'student_school_find'
  match 'students/search' => 'students#search', :via => 'GET', :as => 'student_search'
  match 'students/packages/:id/:i' => 'students#packages', :via => 'GET', :as => 'student_packages'
  match 'students/find/:school' => 'students#find', :via => 'GET', :as => 'student_find'
  match 'orders/create_package' => 'orders#create_package', :via => 'GET', :as => 'order_create_package'
  match 'orders/delete_package' => 'orders#delete_package', :via => 'GET', :as => 'order_delete_package'
  match 'students/packages/:id/select/:i' => 'students#select_package', :via => 'GET', :as => 'student_select_package'
  match 'students/:id/calculate' => 'students#calculate', :via => 'GET', :as => 'student_calculate'
  match 'students/:id/update/:i' => 'students#update', :via => 'PATCH', :as => 'student_update'
  match 'students/packages/:id/review/:i' => 'students#review', :via => 'GET', :as => 'student_review'
  match 'students/packages/:cart_id/final/:i' => 'students#final', :via => 'GET', :as => 'student_final'
  match 'orders/:id' => 'orders#show', :via => 'GET', :as => 'order_show'
  match 'orders/:id/export' => 'orders#export', :via => 'GET', :as => 'order_export'
  match 'students/cart/:cart_id/orders' => 'orders#confirm', :via => 'POST', :as => 'order_confirm'
  match 'students/cart/:cart_id/orders/new' => 'orders#new', :via => 'GET', :as => 'new_order'
  match 'items/:cart_id/orders' => 'corders#confirm', :via => 'POST', :as => 'corder_confirm'
  match 'items/:cart_id/orders/new' => 'corders#new', :via => 'GET', :as => 'new_corder'
  match 'students/cart/:cart_id/update_cart' => 'students#update_cart', :via => 'PATCH', :as => 'update_cart'
  match 'catalog' => 'items#index', :via => 'GET', :as => 'catalog'
  match 'items/cart/:cart_id' => 'items#cart', :via => 'GET', :as => 'items_cart'
  match 'items/cart/:cart_id/quantity' => 'items#quantity', :via => 'GET', :as => 'items_quantity'
  match 'items/cart/:cart_id/update_items' => 'items#update_items', :via => 'patch', :as => 'update_items'
  match 'items/add/:id' => 'items#add', :via => 'GET', :as => 'items_add'
  match 'items/remove/:id' => 'items#remove', :via => 'GET', :as => 'items_remove'

  match 'orders/:id/find' => 'orders#find', :via => 'get', :as => 'order_find'
  match 'orders/:order_id/:student_id/processed' => 'orders#processed', :via => 'GET', :as => 'order_processed'
  match 'orders/:order_id/:student_id/notprocessed' => 'orders#notprocessed', :via => 'GET', :as => 'order_notprocessed'

  match 'orders' => 'orders#index', :via => 'GET', :as => "orders"
  match 'orders/import' => 'orders#import', :via => 'POST', :as => "orders_import"

  resources :searches

  root :to => 'pages#show', :page => 'home'

  match '*page' => 'pages#show', :constraints => proc {|request| Page.paths.include? request.fullpath }, :via => "get"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
