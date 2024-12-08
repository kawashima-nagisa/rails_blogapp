require "rails_helper"

RSpec.describe "About Page", type: :feature do
  before do
    # Qiita記事をモック化
    @mocked_articles = [
      {"title" => "テスト記事1", "url" => "https://example.com/article1", "body" => "本文1", "created_at" => Time.now, "likes_count" => 5},
      {"title" => "テスト記事2", "url" => "https://example.com/article2", "body" => "本文2", "created_at" => Time.now, "likes_count" => 10}
    ]
    allow_any_instance_of(PagesController).to receive(:fetch_qiita_articles).and_return(@mocked_articles)
  end

  it "displays Qiita articles with correct links" do
    visit about_path

    expect(page).to have_link("テスト記事1", href: "https://example.com/article1")
    expect(page).to have_link("テスト記事2", href: "https://example.com/article2")
  end

  it "displays the article summary and metadata" do
    visit about_path

    expect(page).to have_content("本文1")
    expect(page).to have_content("投稿日: #{Time.now.to_date}")
    expect(page).to have_content("いいね: 5")

    expect(page).to have_content("本文2")
    expect(page).to have_content("投稿日: #{Time.now.to_date}")
    expect(page).to have_content("いいね: 10")
  end

  it "displays a fallback message if no articles are found" do
    allow_any_instance_of(PagesController).to receive(:fetch_qiita_articles).and_return([])
    visit about_path

    expect(page).to have_content("記事が見つかりませんでした。")
  end

  it "displays the contact form link" do
    visit about_path
    expect(page).to have_link("お問い合わせページへ", href: new_contact_form_path)
  end
end
