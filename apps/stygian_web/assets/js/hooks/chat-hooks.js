import { pushNotification } from "../push-notifications.js"

/**
 * Adds hooks to the chat screen to automatically scroll to the bottom of the chat.
 * @param {Hooks} Hooks LiveView Hooks 
 */
export function addChatHooks(Hooks) { 
  Hooks.ChatScreen = {
    mounted() {
      scrollElementToEnd(this.el)
    },
    updated() {
      scrollElementToEnd(this.el)
      pushNotification("Nuovo messaggio nella chat")
    },
  }

  Hooks.ChatInput = {
    mounted() {
      this.el.focus()
      this.el.onkeydown = (e) => {
        if (e.key === "Enter") {
          // If the value is not greater than 150 the textarea can't dispatch the event
          if (hasInputSufficientLength(this.el.value) || 
              isMasterPhrase(this.el.value) ||
              isOffPhrase(this.el.value)) {
            // Dispatching the event, that will bubble up to the form
            const event = new Event("submit", { bubbles: true, cancelable: true })
            this.el.form.dispatchEvent(event)
            
            // Clearing the input manually because it can happen that the form
            // from the back end gets stuck and it doesn't remove the chat input.
            this.el.value = ""
          }
          else {
            // If the value is not greated than 200, the phrase cannot be sent, but 
            // the input should not allow the new line character to be added.
            e.preventDefault()
          }
        }
      } 
    }
  }

  /**
    * Scrolls the element to the end of the scroll.
    * @param {HTMLElement} element The element to scroll.
    * @returns {void}
    */
  const scrollElementToEnd = (element) => element.scrollTop = element.scrollHeight

  /**
    * Checks if the input has a sufficient length to be sent.
    * @param {string} value The value of the input.
    * @returns {boolean} True if the input has a sufficient length, false otherwise.
    */
  const hasInputSufficientLength = (value) => value.length >= 150

  /**
    * Checks if the input is a master phrase. This will not automatically transform
    * the phrase into a master phrase, but it will prevent the master being limited 
    * in the phrases they will be able to send.
    * @param {string} value The value of the input.
    * @returns {boolean} True if the input is a master phrase, false otherwise.
    */
  const isMasterPhrase = (value) => value.slice(0, 4) === "*** "

  /**
    * Checks if the input is an off phrase.
    * @param {string} value The value of the input.
    * @returns {boolean} True if the input is an off phrase, false otherwise.
    */
  const isOffPhrase = (value) => value.slice(0, 2) === "+ "
}
