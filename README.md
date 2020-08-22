Bootstrapping

`git clone https://github.com/dshvimer/elixir-docker-starter.git`

`cd elixir-docker-starter`

`docker-compose build`

`docker-compose run app sh`

Once running inside container:

`./init.sh`

Follow prompts... "Y" to all

`exit`

Edit config file to use `db` instead of `localhost` as host for postgres

`docker-compose run mix ecto.create`

`docker-compose up`
