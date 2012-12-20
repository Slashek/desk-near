# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bounding_box do
    top_left {{
      "lat" => 10,
      "lon"=> 10
    }}
    bottom_right {{
      "lat" => -10,
      "lon" => -10
    }}
  end
end
