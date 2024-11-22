// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "popper";
import "bootstrap";
import "trix";
import "@rails/actiontext";
import "controllers";

document.addEventListener("turbo:frame-missing", (event) => {
  console.log("turbo:frame-missing triggered");
  const modal = document.getElementById("modal");
  if (modal) {
    console.log("Clearing modal content");
    modal.innerHTML = ""; // 内容をクリア
  } else {
    console.log("Redirecting to response URL");
    const {
      detail: { response, visit },
    } = event;
    event.preventDefault();
    visit(response.url);
  }
});
document.addEventListener("turbo:before-cache", () => {
  console.log("turbo:before-cache triggered");
  const modal = document.getElementById("modal");
  if (modal) {
    console.log("Resetting modal attributes");
    modal.innerHTML = ""; // フレームの内容をクリア
    modal.removeAttribute("src"); // src属性を削除
    modal.removeAttribute("complete"); // complete属性を削除
  }
});



