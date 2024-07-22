import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "body"];

  toggleForm(event) {
    event.preventDefault(); // デフォルトのリンクの動作をキャンセル
    event.stopPropagation(); // イベントがバブリングしないようにする

    const form = this.formTarget; // data-comments-target="form"で指定された要素を取得
    const commentBody = this.bodyTarget; // data-comments-target="body"で指定された要素を取得
    const editButton = event.target; // クリックされた要素を取得

    form.classList.toggle("d-none"); // フォームの表示/非表示を切り替え
    form.classList.toggle("mt-5"); // フォームにマージントップを追加/削除
    commentBody.classList.toggle("d-none"); // コメント本文の表示/非表示を切り替え
    this.toggleEditButton(editButton); // ボタンのテキストとクラスを切り替え
  }

  toggleEditButton(editButton) {
    if (editButton.innerText === "Edit") {
      editButton.innerText = "Cancel";
      this.toggleEditButtonClass(editButton);
    } else {
      editButton.innerText = "Edit";
      this.toggleEditButtonClass(editButton);
    }
  }

  toggleEditButtonClass(editButton) {
    editButton.classList.toggle("btn-secondary");
    editButton.classList.toggle("btn-warning");
  }
}
