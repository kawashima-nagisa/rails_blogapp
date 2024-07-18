#!/usr/bin/env ruby

require "find"

# 指定ディレクトリ以下のすべてのERBファイルを処理する
Find.find("app/views") do |path|
  next unless path.end_with?(".html.erb")

  # ファイルの内容を読み込み、行末の空白を削除
  content = File.read(path)
  cleaned_content = content.gsub(/[ \t]+$/, "")

  # ファイルを上書き
  File.write(path, cleaned_content)
end

puts "All ERB files have been cleaned."
