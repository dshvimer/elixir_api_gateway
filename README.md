`~/dev $ git clone https://github.com/dshvimer/elixir-docker-starter.git`
`~/dev $ cd elixir-docker-starter`
`~/dev/elixir-docker-starter $ docker-compose build`
`~/dev/elixir-docker-starter $ docker-compose run app sh`
`/app_umbrella #  ./init.sh`
`/app_umbrella #  exit`

Edit config to point to host `db` for postgres

`~/dev/elixir-docker-starter $ docker-compose run mix ecto.create`
`~/dev/elixir-docker-starter $ docker-compose up`
