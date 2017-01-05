var gameId = $(".current-game").data("game-id");

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
    console.log("Message from player channel", data);
    if (data.event == "game_refresh") {
      updateGameBoard(data);
    }

    if (data.event == "new_game") {
      newGameBoard(data);
    }
    // Called when there's incoming data on the websocket for this channel

    function newGameBoard(data) {
      $(".gameShow").html(data.content);
      $(".flashes").html(data.message);
      location.assign(window.location.origin + "/games/" + (gameId + 1));
    }

    function updateGameBoard(data) {
      $(".gameShow").html(data.content);
      $(".flashes").html(data.message);
    }},

  deal: function() {
    return this.perform('deal');
  }
});
