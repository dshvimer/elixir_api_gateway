## Dev

Run `docker-compose up` to start the server. Dashboard serves on port 4000. Gateway on port 4001

Visit `/endpoints` to create a routing table

API Keys are created in the console (this project is still a WIP)

Rate limiting is still hard coded

Gateway i

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
