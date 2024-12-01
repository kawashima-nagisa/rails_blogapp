require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:user) { create(:user, name: "John Doe") }
  let!(:category) { create(:category, name: "Tech") }
  let!(:post1) { create(:post, title: "RubyPost", body: "Ruby is great!", user: user, category: category) }
  let!(:post2) { create(:post, title: "Rails", body: "Rails is awesome!", user: user, category: category) }

  describe "GET #index" do
    context "when no search parameters are provided" do
      it "assigns all posts to @posts" do
        get :index
        expect(assigns(:posts)).to match_array([post1, post2])
      end
    end

    context "when search parameters are provided" do
      it "assigns filtered posts to @posts" do
        get :index, params: { q: { title_cont: "Ruby" } }
        expect(assigns(:posts)).to eq([post1])
      end
    end
  end

  describe "GET #autocomplete" do
    context "with a query string" do
      it "returns posts matching the query in title, body, user name, or category name" do
        get :autocomplete, params: { q: "Ruby" }, format: :js
        expect(assigns(:posts)).to include(post1)
        expect(assigns(:posts)).not_to include(post2)
      end

      it "limits the results to 10 posts" do
        create_list(:post, 15, title: "ExtraPost", body: "Extra content", user: user, category: category)
        get :autocomplete, params: { q: "Extra" }, format: :js
        expect(assigns(:posts).count).to eq(10)
      end

      it "renders the correct partial" do
        get :autocomplete, params: { q: "Ruby" }, format: :js
        expect(response).to render_template(partial: "search/_autocomplete_results")
      end
    end
  end
end
