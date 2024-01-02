import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hide-post"
export default class extends Controller {
  
  static targets = ["undoButton"];

  connect() {
    console.log('hidden_undo_post connected!!')
    // this.dialogTarget.style.display = "none";
  }

  hidePost(event) {
    event.preventDefault();
    const postId = this.data.get("postId");

    fetch(`/posts/${postId}/toggle_hide`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ postId }),
    })
    .then((response) => response.json())
    .then((data) => {
      if (data.hidden) {
        this.showDialog();
      }
    });
  }
  
  undoHidePost() {
    const postId = this.data.get("postId");

    fetch(`/posts/${postId}/toggle_hide`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ postId }),
    })
    .then((response) => response.json())
    .then((data) => {
      if (!data.hidden) {
        this.hideDialog();
      }
    });
  }

  showDialog() {
    this.dialogTarget.style.display = "block";
    this.undoButtonTarget.addEventListener("click", this.undoHidePost.bind(this));
  }

  hideDialog() {
    this.dialogTarget.style.display = "none";
  }

}
