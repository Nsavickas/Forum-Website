FactoryGirl.define do
  factory :user do
    name "Example User"
    sequence(:email) { |n| "example-#{n}@railstutorial.org" }
    password "foobar2000"
    admin false
    activated true
    
    #{} around Time.now creates these times dynamically
    created_at {Time.now}
    activated_at {Time.now}
    
    after(:create) do |user|
      user.notification_configuration = FactoryGirl.create(:notification_configuration, user: user)
    end
  end
  
  factory :user_with_avatar, class: User, :parent => :user do 
    after(:create) do |user|
      user.avatar = FactoryGirl.create(:avatar, :user => user)
    end
  end
  
  factory :user_with_pictures, class: User, :parent => :user do
    after(:create) do |user|
      user.picture = FactoryGirl.create(:user_picture, :user => user)
    end
  end

end
