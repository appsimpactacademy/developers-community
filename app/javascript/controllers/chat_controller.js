import { Controller } from "@hotwired/stimulus"
import StimulusReflex from 'stimulus_reflex';
import consumer from '../channels/consumer';
// import debounce from 'lodash/debounce';



// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ['message'];
  connect() {

    StimulusReflex.register(this)
    this.debounceTimer = null; 

  }

  initialize() {
    // Extract the chatroom ID from the dataset of the chat container
    const chatroomId = this.element.dataset.chatroomId;

    consumer.subscriptions.create({ channel: "ChatChannel", room: `chat_${chatroomId}` }, {
      received: this._cableReceived.bind(this),
    });
  }




  create_message(event) {
    event.preventDefault();

    const otherUserId = event.target.dataset.otherUserId;

    if (this.isActionCableConnectionOpen()) {
      this.stimulate('Chat#create_message', event.target, otherUserId);
      this.stimulate('Chat#update_messages', otherUserId);
      // Clear the input field value
      this.messageTarget.value = '';
    } else {
      console.log('ActionCable connection is not open yet. Waiting...');
    }
  }

  _cableReceived() {
    // Clear any existing debounce timer
    clearTimeout(this.debounceTimer);

    // Set a new debounce timer
    this.debounceTimer = setTimeout(() => {
      console.log("Debounce timer fired");
      const element = document.querySelector('[data-reflex="click->chat#update_messages"]');

      const otherUserId = element.dataset.other_user_id;
      console.log("Selected element:", element);
      if (element) {
        this.stimulate('Chat#update_messages', otherUserId);
      } else {
        console.log("Element not found");
      }
    }, 200); // Adjust the debounce delay as needed
  }

}