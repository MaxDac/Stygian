/**
 * Adds hooks to the chat screen to automatically scroll to the bottom of the chat.
 * @param {Hooks} Hooks LiveView Hooks 
 */
export function addChatHooks(Hooks) { 
  console.debug("Mounting chat hooks...")
  Hooks.ChatScreen = {
    mounted() {
      console.debug("Mounted")
      this.el.scrollTop = this.el.scrollHeight;
    },
    updated() {
      console.debug("Updated")
      this.el.scrollTop = this.el.scrollHeight;
    },
  };
};
