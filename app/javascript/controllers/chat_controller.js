import { Controller } from "@hotwired/stimulus"
import StimulusReflex from 'stimulus_reflex';
import consumer from '../channels/consumer';
// import debounce from 'lodash/debounce';



// Connects to data-controller="chat"
export default class extends Controller {

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

  open_chat(event) {
    event.preventDefault();
    const userId = event.target.getAttribute("data-user-id");
    this.stimulate("ChatReflex#open_chat", userId);
  }

  create_message(event) {
    event.preventDefault();

    const otherUserId = event.target.dataset.otherUserId;

    if (this.isActionCableConnectionOpen()) {
      this.stimulate('Chat#create_message', event.target, otherUserId);
      this.stimulate('Chat#update_messages', otherUserId);
    } else {
      console.log('ActionCable connection is not open yet. Waiting...');
    }
  }

  _cableReceived() {
    // Clear any existing debounce timer
    clearTimeout(this.debounceTimer);

    // Set a new debounce timer
    this.debounceTimer = setTimeout(() => {
      const otherUserId = this.element.dataset.otherUserId;
      if (this.element) {
        this.stimulate('Chat#update_messages', otherUserId);
      } else {
        console.log("Element not found");
      }
    }, 200); // Adjust the debounce delay as needed
  }
}