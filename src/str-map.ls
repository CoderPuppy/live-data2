require! Live: \./

class StrMap extends Live
	(@store) ~>
		super!

		@hist = {}
		@on \newListener, (name, fn) ~>
			m = name.match(/^val:([\S\s]+)$/)
			if m
				fn(@_get-key(m[1]))

	_get: -> @store
	_set: (val) ->
		for k, v of val
			@_set-key k, v

	_set-key: (key, val) -> @_local-update [key, val]
	_get-key: (key) -> @store[key]

	_apply-update: (u) ->
		{source, time, data: [key, val]} = u

		@hist[key] = u

		old-val = @store[key]
		@emit "prechange:#{key}", val, old-val
		@store[key] = val
		@emit "changed:#{key}", val, old-val
		@emit "val:#{key}", val, old-val

		true

	history: ->
		for k, u of @hist
			u

module.exports = StrMap