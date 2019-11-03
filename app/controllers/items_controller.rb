class ItemsController < ApplicationController

  def index
    @items = Item.limit(10).order('id')
  end 

  def show
    @items = Item.new
  end

  def new
    @item = Item.new
    @item.images.build
    # エラーメッセージ用
    @image = Image.new
  end
  def create
    @item = Item.new(create_items_params)
    # エラーメッセージ用
    @image = Image.new
    if @item.save
      redirect_to :root
    else
      render 'new'
    end
  end
  def create_items_params
    # 認証機能できたらcurrent_userに変更する
    params.require(:item).permit(:title, :description, :status, :shipping_charge, :delivery_source, :shipping_day, :shipping_method, :price, images_attributes: [:image]).merge(user_id: 1)
  end

end
