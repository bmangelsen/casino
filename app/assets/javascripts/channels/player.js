App.player = App.cable.subscriptions.create("PlayerChannel", {
  connected: function() {
    console.log("Player Connected");
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    console.log("disconnect");
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    console.log("Got Stuff", data);
    $(".gameShow").html(data.content);
    $(".flashes").html(data.message);
    // Called when there's incoming data on the websocket for this channel
  },

  deal: function() {
    return this.perform('deal');
  }
});
