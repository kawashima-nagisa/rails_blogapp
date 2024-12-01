require "rails_helper"

RSpec.describe Post, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = create(:user)
      category = create(:category)
      post = Post.new(
        title: "ValidTitle",
        body: "This is a valid body",
        user: user,
        category: category
      )
      expect(post).to be_valid
    end
  end

  describe "ransackable attributes" do
    describe ".ransackable_attributes" do
      it "returns the list of searchable attributes" do
        expect(Post.ransackable_attributes).to eq(%w[title body created_at updated_at user_id])
      end
    end

    describe ".ransackable_associations" do
      it "returns the list of searchable associations" do
        expect(Post.ransackable_associations).to eq(["user", "category"])
      end
    end
  end
end
