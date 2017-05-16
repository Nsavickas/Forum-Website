FactoryGirl.define do
  factory :chocolate, class: Item do
    itemname "Chocolate"
    category "Food"
    price 10
    stock 10
    association :user
    created_at {Time.now}
  end
  
  factory :car, class: Item do
    itemname "Car"
    category "Vehicle"
    price 1000
    stock 5
    association :user
    created_at {Time.now}
  end

end
