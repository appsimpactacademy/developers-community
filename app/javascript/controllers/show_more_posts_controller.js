import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["post", "showMore", "showLess"];
  static classes = ["hidden"];

  connect() {
    console.log('Show more posts connected!!')
    this.limit = 3;
    this.updateVisibility();
  }

  showMore() {
    this.limit = this.postTargets.length;
    this.updateVisibility();
  }

  showLess() {
    this.limit = 3;
    this.updateVisibility();
  }

  updateVisibility() {
    this.postTargets.forEach((post, index) => {
      if (index < this.limit) {
        post.classList.remove(this.hiddenClass);
      } else {
        post.classList.add(this.hiddenClass);
      }
    });

    if (this.limit > 3) {
      this.showMoreTarget.classList.add(this.hiddenClass);
      this.showLessTarget.classList.remove(this.hiddenClass);
    } else {
      this.showMoreTarget.classList.remove(this.hiddenClass);
      this.showLessTarget.classList.add(this.hiddenClass);
    }
  }
}
