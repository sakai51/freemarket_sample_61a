namespace :recommendify do
  desc "関連性の取得"
  task :get_relatedness => :environment do
    recommender = MyRecommender.new
    User.all.each do |user|
      ary = []
      user.buyings.each do |buying|
        ary.push(buying.category_id)
      recommender.order_items.add_set(user.id, ary)
      end
    end
    recommender.process!
  end
end
