# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price do
    amount 75.0
    label "$75.00"
    currency_code "USD"
    period "day"
  end
end
