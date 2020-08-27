## Quickstart

Run `docker-compose up` to start the server. Dashboard serves on port 4000. Gateway on port 4001

API Keys (`Gateway.Key`) are created in the console (this project is still a WIP, sorry). Add value to a header named `x-api-key` when making HTTP requests

Visit `/endpoints` to create `Gateway.Endpoint`s. A routing table will be built when the server starts.

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
