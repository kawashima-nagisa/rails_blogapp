require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "associations" do
    it "belongs to a recipient" do
      association = described_class.reflect_on_association(:recipient)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:polymorphic]).to be true
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      user = create(:user)
      notification = Notification.new(
        recipient: user,
        type: "CommentNotification",
        params: { comment: "This is a comment" }
      )
      expect(notification).to be_valid
    end

    it "is invalid without a recipient" do
      notification = Notification.new(
        type: "CommentNotification",
        params: { comment: "This is a comment" }
      )
      expect(notification).not_to be_valid
      expect(notification.errors[:recipient]).to include("を入力してください")
    end

    it "is invalid without a type" do
      user = create(:user)
      notification = Notification.new(
        recipient: user,
        params: { comment: "This is a comment" }
      )
      expect(notification).not_to be_valid
      expect(notification.errors[:type]).to include("を入力してください")
    end
  end

  describe "read/unread functionality" do
    let(:user) { create(:user) }
    let(:notification) do
      Notification.create(
        recipient: user,
        type: "CommentNotification",
        params: { comment: "This is a comment" }
      )
    end

    it "marks a notification as read" do
      notification.update(read_at: Time.current)
      expect(notification.read_at).not_to be_nil
    end

    it "is unread by default" do
      expect(notification.read_at).to be_nil
    end
  end
end
