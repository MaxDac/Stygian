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
        // If the value is not greater than 200 the textarea can't dispatch the event
        if (e.key === "Enter" && this.el.value.length >= 200) {
          // Dispatching the event, that will bubble up to the form
          const event = new Event("submit", { bubbles: true, cancelable: true })
          this.el.form.dispatchEvent(event)
          
          // Clearing the input manually because it can happen that the form
          // from the back end gets stuck and it doesn't remove the chat input.
          this.el.value = ""
        }
      } 
    }
  }
}
