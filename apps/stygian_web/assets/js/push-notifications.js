/**
  * Determines whether the browser supports notifications, if not it logs it,
  * if it supports it asks for permission to the user and logs the result.
  * @returns {void}
  */
export const askNotificationPermission = () => {
  const handlePermission = (_) => {
    console.debug("Permission: ", Notification.permission === "granted" ? "granted" : "denied");
  }

  if ("Notification" in window) {
    Notification.requestPermission()
      .then(handlePermission)
  }
  else {
    console.debug("This browser does not support notifications.");
  }
}

/**
  * Shows a notification with the given body and an optional title.
  * @param {string} body - The body of the notification.
  * @param {string} [title] - The title of the notification.
  * @returns {Promise<Notification>} - The notification.
  */
export const pushNotification = (body, title) => {
  if (document.hidden) {
    const imageUrl = "/favicon.ico"
    const notificationTitle = title || "Stygian - Nuova notifica"

    const notification = new Notification(notificationTitle, {
      body: body,
      icon: imageUrl
    })
    
    return new Promise((resolve, _reject) => {
      document.addEventListener("visibilitychange", (_) => {
        if (document.visibilityState === "visible") {
          resolve(notification)
        }
      })
    })
  }
  else {
    return Promise.resolve()
  }
}
