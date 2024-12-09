require "rails_helper"

RSpec.describe "posts/index", type: :view do
  before do
    user = create(:user, name: "Test User")
    category = create(:category, name: "Category1")
    create(:post, title: "Title 1", body: "Post Body 1", user: user, category: category)
    create(:post, title: "Title 2", body: "Post Body 2", user: user, category: category)

    assign(:posts, Kaminari.paginate_array(Post.all).page(1).per(10))
    assign(:categories, Category.left_joins(:posts).select("categories.*, COUNT(posts.id) AS posts_count").group("categories.id"))
    assign(:recent_posts, Post.order(created_at: :desc).limit(3))
    assign(:category, nil)
    assign(:show_full_content, false)
  end

  it "renders the post list with titles and bodies" do
    render

    expect(rendered).to have_content("投稿された記事一覧")
    expect(rendered).to have_content("Title 1")
    expect(rendered).to have_content("Title 2")
    expect(rendered).to have_content("Post Body 1")
    expect(rendered).to have_content("Post Body 2")
  end

  it "renders the new post link" do
    render
    expect(rendered).to have_link("新しい記事を作成する", href: new_post_path)
  end

  it "renders the sidebar with recent posts" do
    render
    expect(rendered).to have_content("最新の記事")
    expect(rendered).to have_content("Title 1")
    expect(rendered).to have_content("Title 2")
  end

  it "renders the sidebar with categories and post counts" do
    render
    expect(rendered).to have_content("カテゴリー")
    expect(rendered).to have_content("Category1 (2)") # 投稿数を正しく表示
  end
end
