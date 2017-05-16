FactoryGirl.define do
  factory :post do
    postname "Sheep"
    content "Sheep are truly negus"
    association :user
    association :subforum
    sticky false
    created_at {Time.now}
  end
  
  factory :post_with_pictures, class: Post, :parent => :post do 
    after(:create) do |post|
      post.pictures << FactoryGirl.create(:post_picture, :imageable => post)
    end
  end
  
  factory :post_with_comments, class: Post, :parent => :post do 
    after(:create) do |post|
      create_list(:comment, 2, :post => post)
    end
  end
end