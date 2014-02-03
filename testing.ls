require! {
	Live: \./
	Cell: \./cell
	DB: \./db
}

db = DB!

a = Cell('bar')
b = Cell!

db.add a

a.bind b,
	mapper: -> "foo#{it}"
	reverse-mapper: -> it.replace(/^foo/, '')

console.log a.get!, b.get!

b.set 'foobaz'

console.log a.get!, b.get!