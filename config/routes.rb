Rails.application.routes.draw do
  devise_for :users,
  skip: [
    :registration,
    :session
  ],
  controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    # registration
    get    'signup',                         to: 'users/registrations#index',   as: :start_user_registration
    get    'signup/registration',            to: 'users/registrations#new',     as: :new_user_registration
    get    'signup/registration/sns',        to: 'users/registrations#sns',     as: :users_sns
    patch  'users',                          to: 'users/registrations#update',  as: :user_registration
    put    'users',                          to: 'users/registrations#update'
    delete 'users',                          to: 'users/registrations#destroy'
    post   'signup/registration',            to: 'users/registrations#create',  as: :create_user_registration
    post   'signup/sms_confirmation',        to: 'users/registrations#sms',     as: :sms_user_registration
    post    'signup/new_address',             to: 'users/registrations#new_address',  as: :new_address_users
    post    'signup/new_card',                to: 'users/registrations#new_card',  as: :new_card_users
    get   'signup/complete',                to: 'users/registrations#complete',  as: :complete_users
    # session
    get    'login',                 to: 'users/sessions#new',          as: :new_user_session
    post   'login',                 to: 'users/sessions#create',       as: :user_session
    delete 'logout',                to: 'users/sessions#destroy',      as: :destroy_user_session

  end

  get "logout" => "users#logout"
  resources :users do
    collection do
      get:logout
    end
    
    member do
      # 出品中商品
      get :listing
      # 取引中商品
      get :in_progress
      # 売却済み商品
      get :completed
      # 個人情報編集ページ
      get :private_information
      # 配送先編集ページ
      get :address
    end
  end

  resources :users, only: [:show, :edit] do
    resources :cards, only: [:index, :new, :show, :create, :destroy]
  end

  resources :items do
    resources :purchases, only: [:new, :show] do
      collection do 
        post :pay
      end
    end
    member do
      # 自分の商品個別ページ
      get :my_item
    end
    collection do
      # 検索と結果表示
      get :search
    end
  end

  resources :private_informations, only: [:edit, :update]
  resources :categories, only: [:index, :show]
  namespace :api do
    resources :categories, only: :index, defaults: { format: 'json'}
  end

  resources :tests, only: [:index, :new, :show]

  root to: "items#index"

end
