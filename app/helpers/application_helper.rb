module ApplicationHelper
  # RedcarpetとRedcarpet::Render::Stripを読み込む
  require 'redcarpet'
  require 'redcarpet/render_strip'

  # マークダウン形式のテキストをHTMLに変換するメソッド
  def markdown(text)
    # レンダリングのオプションを設定する
    render_options = {
      filter_html:     true,  # HTMLタグのフィルタリングを有効にする
      hard_wrap:       true,  # ハードラップを有効にする
      link_attributes: { rel: 'nofollow', target: "_blank" },  # リンクの属性を設定する
      space_after_headers: true,  # ヘッダー後のスペースを有効にする
      fenced_code_blocks: true  # フェンス付きコードブロックを有効にする
    }

    # HTMLレンダラーを作成する
    renderer = Redcarpet::Render::HTML.new(render_options)

    # マークダウンの拡張機能を設定する
    extensions = {
      autolink:           true,  # 自動リンクを有効にする
      no_intra_emphasis:  true,  # 単語内の強調を無効にする
      fenced_code_blocks: true,  # フェンス付きコードブロックを有効にする
      lax_spacing:        true,  # 緩いスペーシングを有効にする
      strikethrough:      true,  # 取り消し線を有効にする
      superscript:        true  # 上付き文字を有効にする
    }

    # マークダウンをHTMLに変換し、結果をhtml_safeにする
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end

   def markdown_to_plain_text(text)
    renderer = Redcarpet::Render::StripDown.new
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(text)
  end

  
end
