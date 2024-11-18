// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "popper";
import "bootstrap";
import "trix";
import "@rails/actiontext";
import "controllers";

document.addEventListener("turbo:frame-missing", (event) => {
  const {
    detail: { response, visit },
  } = event;
  event.preventDefault();
  visit(response.url); // 現在のURLにリダイレクト
});
