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
          console.debug("Enter pressed")
          // Dispatching the event, that will bubble up to the form
          const event = new Event("submit", { bubbles: true, cancelable: true })
          this.el.form.dispatchEvent(event)
        }
      } 
    }
  }
}
