require "rails_helper"

RSpec.describe ContactForm, type: :model do
  let(:contact_form) { build(:contact_form) }

  describe "validations" do
    it "is valid with valid attributes" do
      contact_form.name = "Test Name"
      contact_form.email = "test@example.com"
      contact_form.message = "This is a test message."
      expect(contact_form).to be_valid
    end

    it "is invalid without a name" do
      contact_form.name = nil
      expect(contact_form).not_to be_valid
      expect(contact_form.errors[:name]).to include("を入力してください")
    end

    it "is invalid if the name is too long" do
      contact_form.name = "a" * 51
      expect(contact_form).not_to be_valid
      expect(contact_form.errors[:name]).to include("は50文字以内で入力してください")
    end

    it "is invalid without an email" do
      contact_form.email = nil
      expect(contact_form).not_to be_valid
      expect(contact_form.errors[:email]).to include("を入力してください")
    end

    it "is invalid with an improperly formatted email" do
      contact_form.email = "invalid_email"
      expect(contact_form).not_to be_valid
      expect(contact_form.errors[:email]).to include("有効なメールアドレスを入力してください")
    end

    it "is invalid without a message" do
      contact_form.message = nil
      expect(contact_form).not_to be_valid
      expect(contact_form.errors[:message]).to include("を入力してください")
    end
  end
end
