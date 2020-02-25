# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout 'sign_up', only: [:new, :sms, :new_address, :sns, :new_card, :complete]
  before_action :pay_key, only: [:new_card]
  def index
  end

  def new
    # sns認証のセッションが残っている場合、リセットします。
    reset_session
    @user = User.new # 新規インスタンス作成
  end

  def sns
    # sns先で使われている名前とメールアドレスをテキストボックスに入った状態をつくります
    @user = User.new(
      nickname:              session[:user_attributes]["nickname"],
      email:                 session[:user_attributes]["email"]
    )
  end

  def sms
    validates_user
    @user = User.new # 新規インスタンス作成
  end

  def new_address
    validates_sms
      @user = User.new # 新規インスタンス作成
  end

  def new_card
    validates_address
    @card = Card.new
  end

  def create
    # カード情報のページをスキップしているためここでaddressのバリデーションチェックをします。本来はnew_cardで行います。
    @user = User.new(
      nickname:              session[:nickname], # sessionに保存された値をインスタンスに渡す
      email:                 session[:email],
      password:              session[:password],
      password_confirmation: session[:password_confirmation],
      family_name:           session[:family_name],
      first_name:            session[:first_name],
      family_kana:           session[:family_kana],
      first_kana:            session[:first_kana],
      birthday:              session[:birthday],
      "birthday(1i)" =>      session["birthday(1i)"],
      "birthday(2i)" =>      session["birthday(2i)"],
      "birthday(3i)" =>      session["birthday(3i)"],
      phone_number:          session[:phone_number],
      postal_code:           session[:postal_code],
      prefectures:           session[:prefectures],
      city:                  session[:city],
      house_number:          session[:house_number],
      building_name:         session[:building_name],
      phone_number:          session[:phone_number],
      phone_number_deliver:  session[:phone_number_deliver]
    )
    if session[:user_attributes].present?
      @user.uid           = session[:user_attributes]["uid"]
      @user.provider      = session[:user_attributes]["provider"]
    end
    @user.save
    PrivateInformation.create(
      user_id:     @user.id,
      family_name: @user.family_name,
      first_name:  @user.first_name,
      family_kana: @user.family_kana,
      first_kana:  @user.first_kana,
      birthday:    @user.birthday
    )
    customer = Payjp::Customer.create(card: params["payjp-token"])
    @card = Card.new(user_id: @user.id, customer_id: customer.id, card_id: customer.default_card)
    if @card.save
      reset_session
      # ログインするための情報を保管
      session[:id] = @user.id
      redirect_to complete_users_path
    end
  end

  def complete
    sign_in User.find(session[:id]) unless user_signed_in?
  end

  private
  # 許可するキーを設定します
  def user_params
    params.require(:user).permit(
      :nickname, 
      :profile,
      :image,
      :email, 
      :password, 
      :password_confirmation, 
      :family_name, 
      :first_name,
      :family_kana,
      :first_kana,
      "birthday(1i)",
      "birthday(2i)",
      "birthday(3i)",
      :postal_code, 
      :prefectures,
      :city,
      :house_number,
      :building_name,
      :phone_number,
      :phone_number_deliver
  )
  end

  # --以下は新規登録のそれぞれのページのバリデーションをチェックをします--
  # "仮"はまだ入力していない情報のバリデーションに引っかかってしまうため、仮置きしています
  def validates_user
    # sns認証で持っているパスワードのセッションが消えないようにします。メールアドレスの登録の場合は新しくセッションに保存します。
    if session[:user_attributes].nil?
      session[:password]              = user_params[:password]
      session[:password_confirmation] = user_params[:password_confirmation]
    end
    # newで入力された値をsessionに保存
    session[:nickname]      = user_params[:nickname]
    session[:email]         = user_params[:email]
    session[:family_name]   = user_params[:family_name]
    session[:first_name]    = user_params[:first_name]
    session[:family_kana]   = user_params[:family_kana]
    session[:first_kana]    = user_params[:first_kana]
    session["birthday(1i)"] = user_params["birthday(1i)"]
    session["birthday(2i)"] = user_params["birthday(2i)"]
    session["birthday(3i)"] = user_params["birthday(3i)"]

    @user = User.new(
      nickname:              session[:nickname],
      email:                 session[:email],
      password:              session[:password],
      password_confirmation: session[:password_confirmation],
      family_name:           session[:family_name],
      first_name:            session[:first_name],
      family_kana:           session[:family_kana],
      first_kana:            session[:first_kana],
      "birthday(1i)" =>      session["birthday(1i)"],
      "birthday(2i)" =>      session["birthday(2i)"],
      "birthday(3i)" =>      session["birthday(3i)"],
      postal_code:           "仮",
      prefectures:           1,
      city:                  "仮",
      house_number:          "仮",
      building_name:         "仮",
      phone_number:          "仮"
    )
    render :new unless @user.valid?
  end

  def validates_sms
    # smsで入力された値をsessionに保存
    session[:phone_number] = user_params[:phone_number]
    @user = User.new(
      phone_number:          session[:phone_number],
      nickname:              session[:nickname],
      email:                 session[:email],
      password:              session[:password],
      password_confirmation: session[:password_confirmation],
      family_name:           session[:family_name],
      first_name:            session[:first_name],
      family_kana:           session[:family_kana],
      first_kana:            session[:first_kana],
      "birthday(1i)" =>      session["birthday(1i)"],
      "birthday(2i)" =>      session["birthday(2i)"],
      "birthday(3i)" =>      session["birthday(3i)"],
      postal_code:           "仮",
      prefectures:           1,
      city:                  "仮",
      house_number:          "仮",
      building_name:         "仮"
    )
    render :sms unless @user.valid?(:sms)
  end

  def validates_address
    session[:postal_code]   = user_params[:postal_code]
    session[:prefectures]   = user_params[:prefectures]
    session[:city]          = user_params[:city]
    session[:house_number]  = user_params[:house_number]
    session[:building_name] = user_params[:building_name]
    session[:phone_number_deliver]  = user_params[:phone_number_deliver]

    @user = User.new(
      nickname:              session[:nickname],
      email:                 session[:email],
      password:              session[:password],
      password_confirmation: session[:password_confirmation],
      family_name:           session[:family_name],
      first_name:            session[:first_name],
      family_kana:           session[:family_kana],
      first_kana:            session[:first_kana],
      "birthday(1i)" =>      session["birthday(1i)"],
      "birthday(2i)" =>      session["birthday(2i)"],
      "birthday(3i)" =>      session["birthday(3i)"],
      postal_code:           user_params[:postal_code],
      prefectures:           user_params[:prefectures],
      city:                  user_params[:city],
      house_number:          user_params[:house_number],
      building_name:         user_params[:building_name],
      phone_number:          session[:phone_number],
      phone_number_deliver:  user_params[:phone_number_deliver]
    )
    render :new_address unless @user.valid?
  end

  def pay_key 
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
  end
end
