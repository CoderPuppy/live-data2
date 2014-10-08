require! Live: \./

class DB extends Live
	~>
		super!

		@lives = {}

	add: (live) ->
		@_local-update [ \r, live ]

	_apply-update: (u) ->
		if Array.is-array(u.data)
			switch u.data[0]
			| \r =>
				live = u.data[1]
				@lives[live.id] = live

				live.registered @
				live.on \_update, (u) ~>
					@_local-update [ \cu, live, u ]
				true
			| \cu =>
				u.data[1]._update(u.data[2])
				true
			| _ =>
				console.log u
				false
		else
			false


module.exports = DB