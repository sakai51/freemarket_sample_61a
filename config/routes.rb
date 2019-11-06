Rails.application.routes.draw do
  devise_for :users, skip: :all,
    controllers: {
    registrations: 'users/registrations',
    sessions: "users/sessions",
  } 

  devise_scope :user do
    # registration
    get    'signup',                         to: 'users/registrations#index',   as: :start_user_registration
    get    'signup/registration',            to: 'users/registrations#new',     as: :new_user_registration
    patch  'users',                          to: 'users/registrations#update',  as: :user_registration
    put    'users',                          to: 'users/registrations#update'
    delete 'users',                          to: 'users/registrations#destroy'
    post   'signup/registration',            to: 'users/registrations#create',  as: :create_user_registration
    get    'signup/sms_confirmation',         to: 'users/registrations#sms',    as: :sms_user_registration
    # session
    get    'login',                 to: 'users/sessions#new',          as: :new_user_session
    post   'login',                 to: 'users/sessions#create',       as: :user_session
    delete 'logout',                to: 'users/sessions#destroy',      as: :destroy_user_session
  end

  # get "logout" => "users#logout"
  resources :users do
    collection do
      get:logout
      get "new_address"
      get "new_card"
      get "complete"
    end
    
    member do
      # 出品中商品
      get :listing
      # 取引中商品
      get :in_progress
      # 売却済み商品
      get :completed
    end
  end

  resources :users, only: [:show, :edit] do
    resources :private_informations, only: [:new]
    resources :cards, only: [:index]
  end

  resources :items do
    resources :purchases
    member do
      # 自分の商品個別ページ
      get :my_item
    end
  end
  resources :tests, only: [:index, :new, :show]

  root to: "items#index"

end

