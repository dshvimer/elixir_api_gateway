defmodule GatewayWeb.ProxyEndpoint do
  use Phoenix.Endpoint, otp_app: :gateway

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :proxy_endpoint]
  plug GatewayWeb.ApiKey
  plug GatewayWeb.RateLimiter
  plug GatewayWeb.DynamicRouter
  # plug ReverseProxyPlug, upstream: "https://api.github.com/"
end
