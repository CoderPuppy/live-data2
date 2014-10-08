// Generated by LiveScript 1.2.0
(function(){
  var Live, DB;
  Live = require('./');
  DB = (function(superclass){
    var prototype = extend$((import$(DB, superclass).displayName = 'DB', DB), superclass).prototype, constructor = DB;
    function DB(){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      DB.superclass.call(this$);
      this$.lives = {};
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    prototype.add = function(live){
      return this._localUpdate(['r', live]);
    };
    prototype._applyUpdate = function(u){
      var live, this$ = this;
      if (Array.isArray(u.data)) {
        switch (u.data[0]) {
        case 'r':
          live = u.data[1];
          this.lives[live.id] = live;
          live.registered(this);
          live.on('_update', function(u){
            return this$._localUpdate(['cu', live, u]);
          });
          return true;
        case 'cu':
          u.data[1]._update(u.data[2]);
          return true;
        default:
          console.log(u);
          return false;
        }
      } else {
        return false;
      }
    };
    return DB;
  }(Live));
  module.exports = DB;
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
