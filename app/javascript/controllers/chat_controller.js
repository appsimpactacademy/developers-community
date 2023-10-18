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

    // Remove the "active" class from all chat windows
    this.userTargets.forEach((user) => {
      user.classList.remove("active");
    });

    // Add the "active" class to the chat window (target) corresponding to the clicked link
    const chatWindow = this.findUserTarget(userId);
    chatWindow.classList.add("active");

    this.stimulate("Chat#open_chat", userId);
  }

  findUserTarget(userId) {
    return this.userTargets.find((user) =>
      user.getAttribute("data-user-id") === userId
    );
  }

  setupFileInput() {
    const fileInputImage = this.element.querySelector("#message_image")
    const fileInputAttachment = this.element.querySelector("#message_attachment")

    fileInputImage.addEventListener('change', this.handleFileSelection.bind(this));
    fileInputAttachment.addEventListener('change', this.handleFileSelection.bind(this));
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

  setupSearchInput() {
    const searchInput = this.searchInputTarget;
    const messageArea = document.querySelector('.message-area');
    
    searchInput.addEventListener('input', () => {

      clearTimeout(this.debounceTimer);
      this.debounceTimer = setTimeout(() => {

        const searchTerm = searchInput.value.toLowerCase().trim();
        
        // Placeholder for fetching messages based on searchTerm
        this.fetchMessages(searchTerm).then((filteredMessages) => {
          if(filteredMessages != undefined){
            const resultInMessages = filteredMessages.map((message) => {
              const messageText = message.message.toLowerCase();
              const chatroomId = message.chatroom_id;
              return {
                foundInMessages: messageText.includes(searchTerm),
                chatroomId: chatroomId
              };
            });

            const foundInMessage = resultInMessages.some((result) => result.foundInMessages);

            this.userTargets.forEach((user) => {
              const userNameElement = user.querySelector('.user-name');
              const userName = userNameElement.textContent.toLowerCase().trim();
              const userMessageElement = user.querySelector('.user-last-message');
              const userMessage = userMessageElement != null ? userMessageElement.textContent.toLowerCase().trim() : '';
              
              // Retrieve chatroom from data attribute
              const UserChatroomId = user.dataset.chatroomId;

              // Check if the otherUserId is present in resultInMessages
              const otherUserIdFound = resultInMessages.some((result) => result.chatroomId == parseInt(UserChatroomId, 10));
            
              if (userName.includes(searchTerm) || userMessage.includes(searchTerm) || (foundInMessage && otherUserIdFound)) {
                user.classList.remove('d-none');
              } else {
                user.classList.add('d-none');
              }
            });
          }else{
            this.userTargets.forEach((element) => element.classList.remove('d-none'));
          }
        });
      }, 500);
    });
  }

  // Placeholder for fetching messages based on searchTerm
  async fetchMessages(searchTerm) {
    if (searchTerm.length > 0) {
      const response = await fetch('/all_messages');
      const allMessages = await response.json();

      // Filter messages based on searchTerm and return the filtered array
      return allMessages.filter((message) =>
        message.message.toLowerCase().includes(searchTerm)
      );
    } else {
      // Return an empty array if searchTerm is empty
      return [];
    }
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
    if(event.target.parentElement.previousElementSibling.value != null){
      image_key = event.target.parentElement.previousElementSibling.value.split('/')[4];
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

