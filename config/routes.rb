require 'sidekiq/web'

Rails.application.routes.draw do


  resources :yearbooks do
    member do
      get :buy
      get :school_user
    end
    collection do 
      get :schools
      get :dashboard
    end
  end

  resources :export_lists

  resources :school_notes do
    member do
      patch :updatenote
    end

    collection do
      get :search
      get :district
      get :school
      get :last
end
end


match 'school_notes/:id/:note' => 'school_notes#note', :via => 'GET', :as => 'note'

  resources :contacts
 
  match 'contact' => 'contacts#new', :via => 'GET'

  resources :types

  resources :templates do
    member do
      get 'copy'
    end
    resources :fields
    resources :pdfs do
      resources :types
    end
  end

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
    resources :packages do
      collection do
        get :carts
        get :export_carts
      end
    end
    resources :pages
    resources :nav_links
    resources :banners

    resources :extra_types

    resources :extras
    match 'users/csv/' => 'users#csv', :via => 'GET', :as => 'users_csv'
    match 'users/import/' => 'users#import', :via => 'POST', :as => 'users_import'

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

  devise_for :users

  match 'export/search/' => 'export_list_items#searches', :via => [:get, :post], :as => 'export_searches'
  match 'export/clear/' => 'export_list_items#clear_students', :via => 'GET', :as => 'export_clear_students'

  match 'export/add_student/:student_id' => 'export_list_items#add_student', :via => 'GET', :as => 'export_add_student'
  match 'export/remove_student/:student_id' => 'export_list_items#remove_student', :via => 'GET', :as => 'export_remove_student'

  match 'export/select_all' => 'export_list_items#select_all', :via => 'GET', :as => 'export_select_all'
  match 'export/deselect_all' => 'export_list_items#deselect_all', :via => 'GET', :as => 'export_deselect_all'


  match 'export/clean_up' => 'export_list_items#clean_up', :via => 'GET', :as => 'export_clean_up'

  match 'export/remove/:id' => 'export_list_items#remove', :via => 'GET', :as => 'export_list_remove'
  match 'export/zip/:school/:package' => 'export_list_items#zip', :via => 'GET', :as => 'export_list_zip'
  match 'orders/add_image/:id/:url' => 'orders#add_image', :via => 'GET', :as => 'orders_add_image'
  match 'export/batch/:school_id' => 'export_list_items#batch', :via => 'GET', :as => 'export_batch'
  match 'export/students' => 'export_list_items#students', :via => 'GET', :as => 'export_students'
  match 'export/users' => 'export_list_items#users', :via => 'GET', :as => 'export_users'
  match 'export/schools' => 'export_list_items#schools', :via => 'GET', :as => 'export_schools'
  match 'export/school_user/:id' => 'export_list_items#school_user', :via => 'GET', :as => 'export_user_school'
  match 'export/show/:id' => 'export_list_items#show', :via => 'GET', :as => 'export_show'
  match 'export/students/:id/:school/type/' => 'export_list_items#types', :via => 'GET', :as => 'export_types'
  match 'export/update/:id/:package' => 'export_list_items#update', :via => 'PATCH', :as => 'export_update'
  match 'export/download/:student_id/:image_id' => 'export_list_items#download', :via => 'GET', :as => 'export_download'
  match 'export/delete/:id' => 'export_list_items#delete', :via => 'delete', :as => 'export_delete'
  match 'export/students/:id/type/:type_id/form/:package' => 'export_list_items#form', :via => 'GET', :as => 'export_form'
  match 'export/students/search/:school' => 'export_list_items#search', :via => 'GET', :as => 'export_search'
  match 'export/students/new/:school/:package' => 'export_list_items#new', :via => 'GET', :as => 'export_new'
  match 'export/students/create/:school/:package' => 'export_list_items#create', :via => 'POST', :as => 'export_create'
  match 'export/waiting/:id/:package' => 'export_list_items#waiting', :via => 'GET', :as => 'export_waiting'
  match 'download' => 'students#find_student', :via => 'GET', :as => 'student_find_student'
  match 'download/images' => 'students#download', :via => 'GET', :as => 'student_download'
  match 'download/download_image/:student/' => 'students#download_image', :via => 'GET', :as => 'student_push_image'
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
  match 'catalog_orders' => 'corders#index', :via => 'GET', :as => 'corders'
  match 'catalog_orders/:id' => 'corders#show', :via => 'GET', :as => 'corder_show'
  match 'catalog_orders/:id/processed' => 'corders#processed', :via => 'GET', :as => 'corders_processed'
  match 'catalog_orders/:id/unprocessed' => 'corders#unprocessed', :via => 'GET', :as => 'corders_unprocessed'
  match 'students/cart/:cart_id/update_cart' => 'students#update_cart', :via => 'PATCH', :as => 'update_cart'
  match 'catalog' => 'items#index', :via => 'GET', :as => 'catalog'
  match 'items/cart/:cart_id' => 'items#cart', :via => 'GET', :as => 'items_cart'
  match 'items/cart/:cart_id/quantity' => 'items#quantity', :via => 'GET', :as => 'items_quantity'
  match 'items/cart/:cart_id/update_items' => 'items#update_items', :via => 'patch', :as => 'update_items'
  match 'items/add/:id/' => 'items#add', :via => 'GET', :as => 'items_add'
  match 'items/filter/:cart/:subcat' => 'items#filter', :via => 'GET', :as => 'items_filter'
  match 'items/all/:cart/' => 'items#all', :via => 'GET', :as => 'items_all'
  match 'items/search/:cart/' => 'items#search', :via => 'GET', :as => 'items_search'
  match 'items/remove/:id/' => 'items#remove', :via => 'GET', :as => 'items_remove'
  match 'items/preview/:id/:cart' => 'items#preview', :via => 'GET', :as => 'items_preview'
  match 'items/next/:id/:cart' => 'items#next', :via => 'GET', :as => 'items_next'
  match 'items/previous/:id/:cart' => 'items#previous', :via => 'GET', :as => 'items_previous'
  match 'items/outside/:cat' => 'items#outside', :via => 'GET', :as => 'items_outside'
  match 'items/cart/:cart_id/cat/:cat' => 'items#cart_outside', :via => 'GET', :as => 'items_cart_outside'

  match 'orders/:id/find' => 'orders#find', :via => 'get', :as => 'order_find'
  match 'orders/:order_id/:student_id/processed' => 'orders#processed', :via => 'GET', :as => 'order_processed'
  match 'orders/:order_id/:student_id/notprocessed' => 'orders#notprocessed', :via => 'GET', :as => 'order_notprocessed'

  match 'orders' => 'orders#index', :via => 'GET', :as => "orders"
  match 'orders/import' => 'orders#import', :via => 'POST', :as => "orders_import"
  match 'corders/import' => 'corders#import', :via => 'POST', :as => "corders_import"
  match 'corders/:id/export' => 'corders#export', :via => 'GET', :as => 'corder_export'
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
