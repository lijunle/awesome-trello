var _lijunle$awesome_trello$Native_WebAPI_Location = function () {
  var location = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
    var location = _elm_lang$core$Native_Utils.update(window.location, {});

    // Deal with Elm reserved word
    location.port$ = location.port;

    // Polyfill for IE
    if (!location.origin) {
      location.origin =
        location.protocol + "//" +
        location.hostname +
        (location.port ? ':' + location.port: '');
    }

    callback(_elm_lang$core$Native_Scheduler.succeed(location));
  });

  return {
    location: location
  };
}();
