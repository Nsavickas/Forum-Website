FactoryGirl.define do
  factory :notification do
    title 'New Post-Like'
    viewed false
    association :user
    association :notifiable, factory: :comment
    created_at {Time.now}
  end

end
