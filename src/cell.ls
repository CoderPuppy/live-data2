require! {
	Live: \./
	through: through2
}

class Cell extends Live
	(@val, force = true) ~>
		super!

		@on \newListener, (name, fn) ~>
			if name == \val
				fn(@get!)

		if force
			@_set @val

	_get: -> @val
	_set: (val) -> @_local-update val

	_get-key: (key) -> Live.get(@get!, key)
	_set-key: (key, val) -> Live.set(@get!, key, val)

	_apply-update: (u) ->		
		old-val = @val

		{source, time, data: new-val} = u
		@_last-update = u

		if new-val != old-val
			@emit \prechange, new-val, old-val
			@val = new-val
			@emit \changed, new-val, old-val
			@emit \val, new-val, old-val

		true

	history: -> [@_last-update]

	_pipe-stream: (opts) ->
		if typeof(opts.mapper) != 'function'
			opts.mapper = -> it

		if typeof(opts.filter) != 'function'
			opts.filter = -> true

		through.obj (u,, done) ->
			if opts.filter(u.data)
				@push {
					u.source, u.time,
					data: opts.mapper(u.data)
				}

			done!

module.exports = Cell