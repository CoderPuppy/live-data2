require! {
	EE: events.EventEmitter
	timestamp: \monotonic-timestamp
	through: through2
	hat
}

class Live extends EE
	->
		@id = hat!
		@sources = {}

	registered: (db) ->
		@emit \registered, db

	get: (key) ->
		if key?
			new Live.Pointer(@, key)
		else
			@_get!

	set: (key, val) ->
		if arguments.length >= 2
			@_set-key key, val
		else if arguments.length >= 1
			@_set key
		else
			throw new Error("#{@constructor.name}#set takes 1 or 2 arguments")

	bind: (other, opts = {}) ->
		a-opts = {}
		b-opts = {}

		for k, v of opts
			m = k.match(/^reverse([A-Z])([\s\S]*)/)

			if m
				b-opts[m[1].to-lower-case! + m[2]] = v
			else
				a-opts[k] = v

		@pipe(other, a-opts).pipe(@, b-opts)

	_pipe-stream: (opts) ->
		through.obj (u,, done) ->
			@push u
			done!

	pipe: (dest, opts = {}) ->
		stream = @_pipe-stream(opts)

		opts.initial = true unless opts.initial?

		@on \_update, (u) ->
			stream.write u

		if opts.initial
			for u in @history!
				if typeof(u) == 'object'
					stream.write u

		stream.on \data, (u) ->
			dest._update u

		dest

	_update: (u) ->
		if not @sources[u.source]? or u.time > @sources[u.source]
			@sources[u.source] = u.time

			if @_apply-update u
				@emit \_update, u

	_local-update: (data) ->
		@_update { source: @id, time: timestamp!, data }

	# history: -> [updates]

	@get = (store, key) ->
		if store instanceof Live
			if key?
				store._get-key key
			else
				store._get!
		else
			if key?
				store[key]
			else
				store

	@set = (store, key, val) ->
		if store instanceof Live
			if arguments.length >= 3
				store._set-key key, val
			else
				store._set key
		else
			if arguments.length >= 3
				store[key] = val
			else
				throw new Error('Cannot set a non-wrapped object')

class Live.Pointer extends Live
	(@kv, @key) ->
		@on \newListener, (name, fn) ~>
			if name == \val
				fn(@get!)

		if @kv instanceof Live
			@kv.on "prechange:#{@key}", (new-val, old-val) ~>
				@emit \prechange, new-val, old-val

			@kv.on "changed:#{@key}", (new-val, old-val) ~>
				@emit \changed, new-val, old-val

			@kv.on "val:#{@key}", (new-val, old-val) ~>
				@emit \val, new-val, old-val

	_set: (new-val) -> Live.set(@kv, @key, new-val)
	_get: -> Live.get(@kv, @key)

module.exports = Live