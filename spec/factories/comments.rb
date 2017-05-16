FactoryGirl.define do
  factory :comment do
    comment_content "Word is Life"
    association :user
    association :post
    created_at {Time.now}
  end
  

end
