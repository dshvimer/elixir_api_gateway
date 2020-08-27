## About

A side project to have fun with.

Features:
1. API Key authentication
2. Rate limiting
3. Mapping endpoints
4. Low latency/high throughput

## Quickstart

Run `docker-compose up` to start the server. Dashboard serves on port 4000. Gateway on port 4001

Run `docker-compose mix do ecto.create, ecto.migrate` to bootstrap the database

Visit `/keys` to create API Keys. Add the value to a header named `x-api-key` when making HTTP requests.

Visit `/endpoints` to create endpoint mappings. A routing table will be built when the server starts. After creating endpoints, restart the server (WIP sorry)

Example endpoint: Path: `/api` -> Upstream: `https://api.github.com/` then make a get request to `localhost:4001/api/zen`

Rate limiting is still hard coded


## Todo

1. Improve `Gateway.RoutingTest`
2. Test `Gateway.Proxy`, create mocks
3. Test `GatewayWeb` plugs
4. Integration tests
5. Endpoint CRUD
6. API Key CRUD
7. Frontend

### Unknowns

Should this run as two separate services? Or one with two open ports?

How complex should routing be? DSL? something like `/users/{id}`?

How to set rate limit rules? config or database?

Different types of rate limiting? By IP, API key, endpoint, global etc
