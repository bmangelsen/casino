var tableId = $(".current-game").data("table-id");

if (tableId !== null) {
  App.table = App.cable.subscriptions.create(
    {
      channel: "TableChannel",
      id: tableId
    }, {
    connected: function() {
      console.log("Connected to Table " + tableId);
      // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) {
      console.log("Message sent!", data);
      $(".gameShow").html(data.content);
      $(".flashes").html(data.message);
      // Called when there's incoming data on the websocket for this channel
    }
  });
}
