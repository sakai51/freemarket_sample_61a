module ItemsHelper
# 2019/12/18 追記　佐々木
# ElastiCacheの請求額が高まってきたのでrecommend機能を停止しました。

#   def recommend(user, canBuy)
#     recommender = MyRecommender.new
#     # もし何も買っていなかったら、空の配列を返す
#     if user.buyings.blank?
#       return []
#     end
#     # 空のハッシュを用意
#     hash_case = {}
#     user.buyings.each do |buying|
#       # 購入した商品の各カテゴリーに対して、最も関連度が高いカテゴリーを調査
#       relate_ary = recommender.for(buying.category_id)[0]
#       unless relate_ary ==nil
#         item_id = recommender.for(buying.category_id)[0].item_id
#         similarity = recommender.for(buying.category_id)[0].similarity
#         hash = {item_id => similarity}
#         hash_case = hash_case.merge(hash)
#       end
#     end
#     if hash_case.blank?
#       # もし何の関連性も見つからなければ[]を返す
#       return []
#     else
#       key_case = []
#       # 関連性が強い順に並び替えて、category_id (ary[0])のみを格納   
#       ary_case = hash_case.sort{|(k1,v1), (k2,v2)|v2<=>v1}
#       ary_case.each do |ary|
#         key_case.push(ary[0])
#       end
#       # recommendsは関連性top8のカテゴリーのアイテム一つずつ。
#       recommends = []
#       key_case.each.with_index do |key, i|
#         item = canBuy.find_by(category_id: key.to_i)
#         unless item == nil
#           recommends.push(item)
#         end
#         if i == 8
#           break;
#         end
#       end
#     end
#     return recommends
#   end
end
