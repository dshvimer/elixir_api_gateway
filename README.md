## Bootstrapping

`git clone https://github.com/dshvimer/elixir-docker-starter.git`

Edit `init.sh`, set app and module names

`cd elixir-docker-starter`

`rm -rf .git`

`docker-compose build`

`docker-compose run app sh`

Once running inside container:

`./init.sh`

Follow prompts... "Y" to all. Once complete, edit `config/dev.exs` to use `db` instead of `localhost` as hostname for postgres

`mix ecto.create`

`exit`

Project is ready to go!

## Development

`docker-compose up` will start the development server

`docker-compose run mix ecto.migrate` to migrate

`docker-compose run mix test` to run tests

Sometimes `docker-compose run` can be slow. I like to run `docker-compose run sh`, and keep an open session inside the container. Then run commands as usual: 

`mix ecto.migrate`

`mix test`
