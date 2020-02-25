# Recommend機能を停止しました。2019.12.18 佐々木
# uri = URI.parse(ENV['REDIS'])
# if Rails.env == 'production'
#   Recommendify.redis = Redis.new(host: "recommend.1zgi2i.ng.0001.apne1.cache.amazonaws.com", port: 6379)
# else
#   Recommendify.redis = Redis.new(host: '127.0.0.1', port: 6379)
# end
# class MyRecommender < Recommendify::Base

#   max_neighbors 50

#   input_matrix :order_items,
#     similarity_func: :jaccard,
#     weight: 5.0

# end