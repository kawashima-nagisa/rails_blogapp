import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static initialized = false; // 初期化済みかを記録

  connect() {
    console.log("GSAP Stimulus Controller connected!");

    // 初期化済みの場合は処理をスキップ
    if (this.constructor.initialized) {
      console.log("GSAP is already initialized.");
      return;
    }

    // グローバルスコープのgsapとScrollTriggerを使用
    if (typeof gsap === "undefined" || typeof ScrollTrigger === "undefined") {
      console.error("GSAPまたはScrollTriggerがロードされていません。");
      return;
    }

    gsap.registerPlugin(ScrollTrigger);

    this.initAnimation();

    // 初期化フラグを設定
    this.constructor.initialized = true;

    // ページ復元時に再初期化
    window.addEventListener("pageshow", this.onPageShow.bind(this));
  }

  initAnimation() {
    const contentElement = this.element.querySelector(".section-top-text__content");
    if (!contentElement) {
      console.warn("要素 '.section-top-text__content' が見つかりません。");
      return;
    }

    gsap.to(contentElement, {
      y: "-100%",
      ease: "none",
      scrollTrigger: {
        trigger: ".section-top",
        start: "top top",
        end: () => "+=" + contentElement.offsetHeight,
        pin: ".section-top",
        scrub: true,
        onEnter: () => this.applyBackgroundStyle(),
        onLeave: () => this.removeBackgroundStyle(),
        onEnterBack: () => this.applyBackgroundStyle(),
        onLeaveBack: () => this.removeBackgroundStyle(),
      },
    });
  }

  applyBackgroundStyle() {
    const sectionTopText = this.element.querySelector(".section-top-text");
    if (sectionTopText) {
      sectionTopText.style.backgroundColor = "rgba(36, 35, 35, 0.302)";
    }
  }

  removeBackgroundStyle() {
    const sectionTopText = this.element.querySelector(".section-top-text");
    if (sectionTopText) {
      sectionTopText.style.backgroundColor = "transparent";
    }
  }

  onPageShow(event) {
    if (event.persisted) {
      console.log("ページがbfcacheから復元されました。再初期化します。");
      this.initAnimation();
    }
  }
}
