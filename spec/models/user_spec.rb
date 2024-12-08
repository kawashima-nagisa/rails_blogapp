require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    let(:user) { build(:user) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user.name = nil
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "is invalid if the name exceeds 20 characters" do
      user.name = "a" * 21
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("は20文字以内で入力してください")
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "is invalid with an improperly formatted email" do
      user.email = "invalid_email"
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("は不正な値です")
    end

    it "is invalid without a unique email" do
      create(:user, email: "test@example.com")
      user.email = "test@example.com"
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it "is valid with a password between 6 and 10 characters" do
      user.password = "123456"
      user.password_confirmation = "123456"
      expect(user).to be_valid
    end

    it "is invalid with a password shorter than 6 characters" do
      user.password = "12345"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "is invalid with a password longer than 10 characters" do
      user.password = "12345678901"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("は10文字以内で入力してください")
    end

    it "is valid with a valid URL in twitter" do
      user.twitter = "https://twitter.com/username"
      expect(user).to be_valid
    end

    it "is invalid with an improperly formatted twitter URL" do
      user.twitter = "invalid_url"
      expect(user).not_to be_valid
      expect(user.errors[:twitter]).to include("有効なURLを入力してください")
    end
  end

  describe "associations" do
    it "has many posts" do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq(:has_many)
    end

    it "has many comments" do
      association = described_class.reflect_on_association(:comments)
      expect(association.macro).to eq(:has_many)
    end

    it "has many notifications as recipient" do
      association = described_class.reflect_on_association(:notifications)
      expect(association.macro).to eq(:has_many)
    end
  end

  # describe "profile image validations" do
  #   let(:user) { build(:user) }
  #   it "is valid with a supported content type" do
  #     user.profile_image.attach(
  #       io: File.open(Rails.root.join("spec/fixtures/files/sample.jpg")),
  #       filename: "sample.jpg",
  #       content_type: "image/jpeg"
  #     )
  #     expect(user).to be_valid
  #   end

  #   it "is invalid with an unsupported content type" do
  #     user.profile_image.attach(
  #       io: File.open(Rails.root.join("spec/fixtures/files/sample.txt")),
  #       filename: "sample.txt",
  #       content_type: "text/plain"
  #     )
  #     expect(user).not_to be_valid
  #     expect(user.errors[:profile_image]).to include("ファイル形式はJPEG, JPG, PNG, GIF, WEBPのみ許可されています。")
  #   end

  #   it "is invalid if the file size exceeds 1MB" do
  #     user.profile_image.attach(
  #       io: File.open(Rails.root.join("spec/fixtures/files/large_image.jpg")),
  #       filename: "large_image.jpg",
  #       content_type: "image/jpeg"
  #     )
  #     allow(user.profile_image.blob).to receive(:byte_size).and_return(2.megabytes)
  #     expect(user).not_to be_valid
  #     expect(user.errors[:profile_image]).to include("1MB以下のファイルをアップロードしてください。")
  #   end
  # end

  describe ".ransackable_attributes" do
    it "returns the list of searchable attributes" do
      expect(User.ransackable_attributes).to eq(%w[email name created_at updated_at])
    end
  end

  describe "#active?" do
    let(:user) { build(:user) }
    it "returns true if the user is active in the last 24 hours" do
      user.current_sign_in_at = 1.hour.ago
      expect(user.active?).to be_truthy
    end

    it "returns false if the user is not active in the last 24 hours" do
      user.current_sign_in_at = 2.days.ago
      expect(user.active?).to be_falsey
    end
  end
end
