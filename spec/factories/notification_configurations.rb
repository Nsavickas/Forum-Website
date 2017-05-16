FactoryGirl.define do
  factory :notification_configuration do
    notify_friendships true
    notify_likes true
    notify_comments true
    association :user
    created_at {Time.now}
  end
end
