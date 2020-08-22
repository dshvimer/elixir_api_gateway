Bootstrapping

`git clone https://github.com/dshvimer/elixir-docker-starter.git`

`cd elixir-docker-starter`

`docker-compose build`

`docker-compose run app sh`

Once running inside container:

`./init.sh`

Follow prompts... "Y" to all. Once complete, edit `config/dev.exs` to use `db` instead of `localhost` as hostname for postgres

`mix ecto.create`

`exit`

Project is ready to go!

`docker-compose up`
