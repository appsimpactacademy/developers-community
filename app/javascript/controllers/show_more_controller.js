import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["description", "toggleButton"];

  connect() {
    console.log('show more connected!!!')
    this.showLess();
    this.toggleButtonVisibility();
  }
  
  toggleVisibility() {
    if (this.isDescriptionVisible()) {
      this.showLess();
    } else {
      this.showMore();
    }
    this.toggleButtonVisibility(); // Update button visibility after toggling
  }

  showMore() {
    this.descriptionTarget.style.maxHeight = "none";
    this.toggleButtonTarget.textContent = "Show Less";
  }

  showLess() {
    this.descriptionTarget.style.maxHeight = "4em"; 
    this.toggleButtonTarget.textContent = "Show More";
  }

  isDescriptionVisible() {
      return this.descriptionTarget.style.maxHeight !== "4em";
  }

  toggleButtonVisibility() {
    const description = this.descriptionTarget;
    const toggleButton = this.toggleButtonTarget;
    
    // Get the computed height of the description
    const computedStyle = window.getComputedStyle(description);
    const descriptionHeight = parseFloat(computedStyle.getPropertyValue("height"));
    
    // Show the button if the description is taller than 2 lines
    if (descriptionHeight > 2 * parseFloat(computedStyle.getPropertyValue("line-height"))) {
      toggleButton.style.display = "block";
      this.descriptionTarget.style.overflow = "hidden";
    } else {
      toggleButton.style.display = "none";
    }
  }
}
