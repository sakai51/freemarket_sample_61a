class ItemsController < ApplicationController

  before_action :set_item, only: [:edit,:update,:destroy,:my_item]
  before_action :set_canbuy, only: :index
  before_action :authenticate_user!, except: [:index, :show, :search]
  skip_before_action :set_search, only: :search
  def index
    # 2019/12/18 追記　佐々木
    # ElastiCacheの請求額が高まってきたのでrecommend機能を停止しました。
    # if user_signed_in?
    #   @recommends = self.class.helpers.recommend(current_user, @canBuy)
    # end
    @ladis         = @canBuy.where(category_id: Category.find(1).subtree_ids).order(id: :desc).limit(8)
    @mens          = @canBuy.where(category_id: Category.find(200).subtree_ids).order(id: :desc).limit(8)
    @toys          = @canBuy.where(category_id: Category.find(685).subtree_ids).order(id: :desc).limit(8)
    @electronics   = @canBuy.where(category_id: Category.find(898).subtree_ids).order(id: :desc).limit(8)
    @chanels       = @canBuy.where(dealing: 0).ransack(brand_cont_any: ["シャネル","CHANEL"]).result.order(id: :desc).limit(8)
    @louisvuittons = @canBuy.where(dealing: 0).ransack(brand_cont_any: ["ルイヴィトン","ルイ・ヴィトン","Louis Vuitton"]).result.order(id: :desc).limit(8)
    @nikes          = @canBuy.where(dealing: 0).ransack(brand_cont_any: ["nike","NIKE","ナイキ"]).result.order(id: :desc).limit(8)
  end 

  def show
    @item = Item.find(params[:id])
    @items = Item.limit(6).order('id')
  end

  def new
    @item = Item.new
    10.times { @item.images.build }
    # 写真0枚のエラーメッセージ用
    @image = Image.new
    render :new, layout: "noheader"
  end
  
  def create
    @item = Item.new(create_items_params)
    
    # 写真0枚のエラーメッセージ用
    @image = Image.new
    if @item.save
      redirect_to :root
    end
  end

  def edit
    10.times { @item.images.build }
    render :edit, layout: "noheader"
  end

  def update
    # 写真0枚のエラーメッセージ用
    @image = Image.new
    if @item.update(update_items_params)
      redirect_to :root
    else
      render 'edit'
    end
  end

  def destroy
    if @item.destroy
      redirect_to listing_user_path(current_user)
    else
      flash.now[:alert] = "削除が失敗しました"
      render action: :index
    end
  end

  def my_item

  end

  def search
      if params[:q][:title_or_description_or_brand_cont].present?
        @name = params[:q][:title_or_description_or_brand_cont] + " の"
      end
      if params[:q][:category_id_in].present?
        root_id = params[:q][:category_id_in]
        children_ids = Category.find(root_id).subtree_ids
        params[:q][:category_id_in] = children_ids
      end
      @search = Item.ransack(params[:q])
      @items = @search.result.where(dealing: 0)
  end

  private

  def create_items_params
    params.require(:item).permit(:title, :description, :status, :shipping_charge, :delivery_source, :shipping_day, :shipping_method, :price, :category_id, :brand, images_attributes: [:image]).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_canbuy
    @canBuy = Item.where(dealing: 0)
  end

  def update_items_params
    params.require(:item).permit(:title, :description, :status, :shipping_charge, :delivery_source, :shipping_day, :shipping_method, :price, :category_id, :brand, images_attributes: [:image, :id, :_destroy]).merge(user_id: current_user.id)
  end

end
