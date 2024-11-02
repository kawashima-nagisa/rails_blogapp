import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modals"
export default class extends Controller {
  close(e) {
    e.preventDefault();
    const modal = document.getElementById("modal");

    if (modal) {
      modal.innerHTML = "";
      modal.removeAttribute("src"); // src属性の削除（Turboフレームをリセット）
      modal.removeAttribute("complete"); // complete属性の削除
      setTimeout(() => {
        window.location.reload();
      }, 100);
    }
  }
}
