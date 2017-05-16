FactoryGirl.define do
  factory :subforum do
    subforumname "General Discussion"
    association :forum
    created_at {Time.now}
  end
  
  factory :subforum_with_posts, :parent => :subforum do 
    after(:create) do |subforum|
      create_list(:post, 10, :subforum => subforum)
    end
  end
end
