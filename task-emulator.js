TaskEmulator = (function() {
  function configure(input, output, f) {
    output.subscribe(function(msg) {
      var id = msg[0];
      var value = msg[1];
      f(value, function(data) {
        input.send([id, data]);
      });
    });
  }
  function eval_(value, done) {
    var args = value.args;
    function succeed(value) {
      done([null, value])
    }
    function fail(e) {
      done([typeof e === 'undefined' ? null : e, null])
    }
    // Note: don't add try-catch. Let it crash!
    // Errors occur only caused by external condition.
    // Other errors (aka runtime-error) should be avoided by library author.
    eval(value.script);
  };
  return {
    configure: configure,
    eval: eval_
  };
}());

//TODO module support
