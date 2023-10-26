import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy-url"
export default class extends Controller {
  static targets = ['copyButton'];
  connect() {
    console.log('Copy URL Connected')
  }

  initialize() {
    console.log('Initialize method called');
    this.element.setAttribute('data-action', 'click->copy-url#copyUrl');
  }

  copyUrl() {
    const postId = this.data.get('postId');

    // Check if postId is not null or undefined
    if (postId !== null && postId !== undefined) {
      const url = `${window.location.origin}/posts/${postId}`;

      const textArea = document.createElement('textarea');
      textArea.value = url;
      document.body.appendChild(textArea);
      textArea.select();
      document.execCommand('copy');
      document.body.removeChild(textArea);

      alert('URL copied to clipboard!');
    } else {
      // Handle the case where postId is null or undefined
      alert('Unable to copy URL. Post ID is missing.');
    }
  }
}
