NinjaChallenge::Application.routes.draw do
  get 'admins/create_test' => 'admins#create_test'
  get 'admins/view_tests' => 'admins#view_tests'

  post 'admins/add_test' => 'admins#add_test'

  devise_for :students do
    get 'students/sign_out'  => 'devise/sessions#destroy', :as => :destroy_student_session
    get 'students/sign_up' => 'registrations#new', :as => :students_sign_up_url
    post 'students' => 'registrations#create'
    match 'student' => 'students#index', :as => :student_root
  end

  devise_for :admins do
    get 'admins/sign_out'  => 'devise/sessions#destroy', :as => :destroy_admin_session
    get 'admins/sign_up' => 'registrations#new', :as => :admins_sign_up_url
    post 'admins' => 'registrations#create'
    match 'admin' => 'admins#index', :as => :admin_root
  end
  
  # Overriding devise controller - Done to load all the levels before showing up the registration page.
  devise_for :students, :controllers => {:registrations => "registrations"}

  resources :students

  resources :admins

  resources :tests

  
  get "home/index"

  get "home/levels"

  get "chart/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  root :to => "home#index"
    
end
