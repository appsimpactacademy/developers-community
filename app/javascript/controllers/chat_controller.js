import { Controller } from "@hotwired/stimulus"
import StimulusReflex from 'stimulus_reflex';
import consumer from '../channels/consumer';
import {EmojiButton} from '@joeattardi/emoji-button'


// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ['textarea', 'searchInput', 'user'];

  connect() {
    StimulusReflex.register(this)
    this.debounceTimer = null;
    this.setupFileInput();
    this.setupEmojiPicker();
  }

  setupFileInput() {
    const fileInput = this.element.querySelector("#message_image");
    fileInput.addEventListener('change', this.handleFileSelection.bind(this));
  }

  setupEmojiPicker() {
    this.picker = new EmojiButton();

    this.picker.on('emoji', (selection) => {
      this.insertEmoji(selection.emoji);
    });
  }

  insertEmoji(emoji) {
    const textarea = this.element.querySelector("#message_message");
    const { selectionStart, selectionEnd } = textarea;
    const textBeforeCursor = textarea.value.substring(0, selectionStart);
    const textAfterCursor = textarea.value.substring(selectionEnd);
    textarea.value = textBeforeCursor + emoji + ' ' + textAfterCursor;
    this.picker.togglePicker(this.element);
    textarea.dispatchEvent(new Event('input', { bubbles: true, cancelable: true }));
  }

  showPicker(event) {
    event.preventDefault()
    this.picker.togglePicker(event.target)
  }

  // Add a new function to handle search input
  setupSearchInput() {
    const searchInput = this.searchInputTarget;
    const messageArea = document.querySelector('.message-area');

    searchInput.addEventListener('input', () => {
      const searchTerm = searchInput.value.toLowerCase().trim();
      const chatroomMessages = messageArea.querySelector('.chatroom-messages');
      const messages = Array.from(chatroomMessages.querySelectorAll('.message'));

      const resultInMessages = messages.map((message) => {
        const messageText = message.textContent.toLowerCase();
        const otherUserId = message.dataset.otherUserId;
        return {
          foundInMessages: messageText.includes(searchTerm),
          otherUserId: otherUserId,
        };
      });

      const foundInMessages = resultInMessages.some((result) => result.foundInMessages);

      this.userTargets.forEach((user) => {
        const userNameElement = user.querySelector('.user-name');
        const userName = userNameElement.textContent.toLowerCase().trim();
        const userMessageElement = user.querySelector('.user-last-message');
        const userMessage = userMessageElement != null ? userMessageElement.textContent.toLowerCase().trim() : '';
        
        // Retrieve otherUserId from data attribute
        const otherUserChatroom = user.dataset.userId;

        // Check if the otherUserId is present in resultInMessages
        const otherUserIdFound = resultInMessages.some((result) => result.otherUserId === otherUserChatroom);

        if (userName.includes(searchTerm) || userMessage.includes(searchTerm) || (foundInMessages && otherUserIdFound)) {
          user.classList.remove('d-none');
        } else {
          user.classList.add('d-none');
        }

        // You can use otherUserId as needed here
        // console.log('OtherUserId:', otherUserId);
      });
    });
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

    this.stimulate("Chat#open_chat", userId);
  }

  handleFileSelection(event) {
    const file = event.target.files[0];
    const otherUserId = event.target.nextElementSibling.dataset.otherUserId;
    if (file) {
      const upload = new ActiveStorage.DirectUpload(file, '/rails/active_storage/direct_uploads');

      upload.create((error, blob) => {
        if (error) {
          // Handle error
        } else {
          // Construct the URL using the key
          const uploadedFileUrl = `/rails/active_storage/blobs/${blob.key}`;

          // Include the file object and uploadedFileUrl in the event data
          const eventData = {
            file: file,
            uploadedFileUrl: uploadedFileUrl,
          };
          document.getElementById('cover_image_key').value = uploadedFileUrl;
        }
      });
    }
  }

  create_message(event) {
    event.preventDefault();
    const otherUserId = event.target.dataset.otherUserId;
    let image_key = null;
    if(event.target.previousElementSibling.value != null){
      image_key = event.target.previousElementSibling.value.split('/')[4];
    }
    if (this.isActionCableConnectionOpen()) {
      this.stimulate('Chat#create_message', event.target, {image_key, otherUserId});
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

