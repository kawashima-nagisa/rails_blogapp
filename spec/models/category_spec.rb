require "rails_helper"

RSpec.describe Category, type: :model do
  let(:category) { build(:category) }

  describe "validations" do
    it "is valid with a name" do
      category.name = "Test Category"
      expect(category).to be_valid
    end

    it "is invalid without a name" do
      category.name = nil
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("を入力してください")
    end
  end

  describe "associations" do
    it "has many posts" do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq(:has_many)
    end

    it "destroys associated posts when destroyed" do
      category = create(:category)
      post = create(:post, category: category)
      expect { category.destroy }.to change { Post.count }.by(-1)
    end
  end

  describe ".ransackable_attributes" do
    it "returns the correct searchable attributes" do
      expect(Category.ransackable_attributes).to eq(%w[name])
    end
  end
end
