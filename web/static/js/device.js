export var Device = {
  off: function(id, callback) {
    var request = new XMLHttpRequest();
    request.addEventListener("load", callback);
    request.open("GET", "/turn_off/" + id);
    request.send();
  }
}
