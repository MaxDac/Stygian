/**
 * Adds hooks to the chat screen to automatically scroll to the bottom of the chat.
 * @param {Hooks} Hooks LiveView Hooks 
 */
export function addChatHooks(Hooks) { 
  Hooks.ChatScreen = {
    mounted() {
      this.el.scrollTop = this.el.scrollHeight
    },
    updated() {
      this.el.scrollTop = this.el.scrollHeight
    },
  }

  Hooks.ChatInput = {
    mounted() {
      this.el.focus()
      this.el.onkeydown = (e) => {
        if (e.key === "Enter") {
          console.log("The element", this.el)
          console.log("The element value length", this.el.value.length)
          // If the value is not greater than 150 the textarea can't dispatch the event
          if (this.el.value.length >= 150) {
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
}
