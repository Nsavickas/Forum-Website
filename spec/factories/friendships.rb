FactoryGirl.define do
  factory :friendship do
    association :friender, class: User, factory: :user
    association :friended, class: User, factory: :user
    accepted true
    created_at {Time.now}
  end

end
