// Generated by LiveScript 1.2.0
(function(){
  var Live, StrMap;
  Live = require('./');
  StrMap = (function(superclass){
    var prototype = extend$((import$(StrMap, superclass).displayName = 'StrMap', StrMap), superclass).prototype, constructor = StrMap;
    function StrMap(store){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      this$.store = store;
      StrMap.superclass.call(this$);
      this$.hist = {};
      this$.on('newListener', function(name, fn){
        var m;
        m = name.match(/^val:([\S\s]+)$/);
        if (m) {
          return fn(this$._getKey(m[1]));
        }
      });
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    prototype._get = function(){
      return this.store;
    };
    prototype._set = function(val){
      var k, v, results$ = [];
      for (k in val) {
        v = val[k];
        results$.push(this._setKey(k, v));
      }
      return results$;
    };
    prototype._setKey = function(key, val){
      return this._localUpdate([key, val]);
    };
    prototype._getKey = function(key){
      return this.store[key];
    };
    prototype._applyUpdate = function(u){
      var source, time, ref$, key, val, oldVal;
      source = u.source, time = u.time, ref$ = u.data, key = ref$[0], val = ref$[1];
      this.hist[key] = u;
      oldVal = this.store[key];
      this.emit("prechange:" + key, val, oldVal);
      this.store[key] = val;
      this.emit("changed:" + key, val, oldVal);
      this.emit("val:" + key, val, oldVal);
      return true;
    };
    prototype.history = function(){
      var k, ref$, u, results$ = [];
      for (k in ref$ = this.hist) {
        u = ref$[k];
        results$.push(u);
      }
      return results$;
    };
    return StrMap;
  }(Live));
  module.exports = StrMap;
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);