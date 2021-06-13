mix-deps: mix.exs
	mix deps.get

node-deps: assets/package.json
	(cd assets && npm i)

deps: mix-deps node-deps

start-dev: deps
	mix phx.server