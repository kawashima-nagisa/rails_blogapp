import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modals"
export default class extends Controller {
  close(e) {
    e.preventDefault();
    const modal = document.getElementById("modal");

    if (modal) {
      modal.innerHTML = ""; // モーダル内容をリセット
      modal.setAttribute("src", ""); // フレームのsrcを空にする
      modal.removeAttribute("complete"); // complete属性を削除
    }
  }
}
