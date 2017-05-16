FactoryGirl.define do
  factory :post_like, class: Like do
    association :user
    association :post
  end
  
  factory :comment_like, class: Like do 
    association :user
    association :comment
  end
  
  factory :duplicate_like, class: Like do
    user_id 1
    likeable_id 1
    likeable_type "Post"
  end

end
