var pathComponents = window.location.pathname.split("/");
var gameId = parseInt(pathComponents[2]);

if (pathComponents[1] == "games" && "" + gameId) {
  App.game = App.cable.subscriptions.create({
      channel: "GameChannel",
      id: gameId
    }, {
    connected: function() {
      console.log("Connected to Game", gameId);
      // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) {
      console.log("Card Dealt", data);
      $(".gameShow").html(data.content);
      // $(".cardShow").html("lol");
      $(".flashes").html(data.message);
      // Called when there's incoming data on the websocket for this channel
    },

    start: function() {
      return this.perform('start');
    }
  });
}
