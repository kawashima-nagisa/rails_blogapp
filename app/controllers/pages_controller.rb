require "net/http"
require "json"

class PagesController < ApplicationController
  def home
  end

  def about
    @articles = fetch_qiita_articles("nagisa-afadfadf") # QiitaユーザーIDに置き換えてください
  end

  private

  def fetch_qiita_articles(user_id)
    url = URI("https://qiita.com/api/v2/users/#{user_id}/items")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request[
      "Authorization"
    ] = "Bearer #{Rails.application.credentials.dig(:qiita, :access_token)}"

    response = http.request(request)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end
end
