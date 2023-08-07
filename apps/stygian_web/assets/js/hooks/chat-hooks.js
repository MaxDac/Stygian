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
      this.el.onkeyup = (e) => {
        if (e.key === "Enter") {
          // Simulating pressing the button because submitting the form would result in 
          // messing with liveview internal behaviour
          this.el.form.querySelector("#chat-input-sender").click()
        }
      } 
    }
  }
}