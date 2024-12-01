FactoryBot.define do
  factory :contact_form do
    name { "Test Name" }
    email { "test@example.com" }
    message { "This is a test message." }
  end
end
