FactoryGirl.define do
  factory :forum do
    forumname "Planetside2"
    created_at {Time.now}
    
  end
  
  factory :forum_with_subforums, :parent => :forum do 
    after(:create) do |forum|
      create_list(:subforum, 1, :forum => forum)
    end
  end
end
