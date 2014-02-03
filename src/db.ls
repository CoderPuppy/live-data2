class DB
	~>
		@lives = {}

	add: (live) ->
		@lives[live.id] = live

module.exports = DB