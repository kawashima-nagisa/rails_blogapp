import { Controller } from "@hotwired/stimulus";

function getCsrfToken() {
  return document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content");
}

export default class extends Controller {
  static targets = ["input", "results", "hidden"];
  static values = { url: String };

  connect() {
    this.inputTarget.addEventListener("input", this.onInputChange.bind(this));

    // ドキュメント全体でクリックイベントを監視
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

  disconnect() {
    // コントローラが外れるときにイベントリスナーを削除
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  onInputChange() {
    const query = this.inputTarget.value;
    if (query.length >= 2 && this.hasUrlValue) {
      this.fetchResults(query);
    }
  }

  fetchResults(query) {
    fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`, {
      method: "GET",
      headers: {
        "X-CSRF-Token": getCsrfToken(),
        Accept: "text/javascript",
      },
    })
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok");
        return response.text();
      })
      .then((html) => {
        this.resultsTarget.innerHTML = html;

        // 検索結果のリスト項目が生成された後でクリックイベントをバインド
        this.resultsTarget.querySelectorAll("li").forEach((item) => {
          item.addEventListener("click", () => {
            this.inputTarget.value = item.dataset.autocompleteLabel;
            this.resultsTarget.innerHTML = ""; // 結果リストをクリア
          });
        });
      })
      .catch((error) =>
        console.error("Error fetching autocomplete results:", error),
      );
  }

  // 検索フォーム以外をクリックした場合にリストを閉じる
  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.innerHTML = ""; // リストをクリア
    }
  }
}
