import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select"];

  connect() {
    console.log("Hello, Stimulus!", this.element);
    console.log(this.selectTarget.value);
  }

  sortPosts() {
    const sortBy = this.selectTarget.value;
    const url = `/home/sort?sort_by=${sortBy}`;

    // Navigate to the home_sort route
    Turbo.visit(url);
  }

  update() {
    console.log("update");
    this.sortPosts();
  }
}
