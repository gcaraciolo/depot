import consumer from "./consumer"

consumer.subscriptions.create("ProductsChannel", {
  connected() {
    console.log('connected');
  },

  disconnected() {
    console.log('desconnected');
  },

  received(data) {
    const storeElement = document.querySelector("main.store")
    if (storeElement) storeElement.innerHTML = data.html
  }
});
