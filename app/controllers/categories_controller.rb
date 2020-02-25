class CategoriesController < ApplicationController

  def index
    # カテゴリー一覧用、未実装
  end

  def show
    @category = Category.find(params[:id])
    @items = Item.where(category_id: @category.subtree_ids)
  end


end
