// app/javascript/controllers/profile-view_controller.js
import { Controller } from "@hotwired/stimulus";
import StimulusReflex from 'stimulus_reflex';

export default class extends Controller {
  static targets = ["modal"];

  connect() {
    StimulusReflex.register(this)
  }

  viewProfile() {
    const userId = event.target.dataset.userId;
    this.stimulate('ProfileViewReflex#view_profile', userId);
  }
}
