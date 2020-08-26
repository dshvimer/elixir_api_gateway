defmodule GatewayWeb.ProxyEndpoint do
  use Phoenix.Endpoint, otp_app: :gateway

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug GatewayWeb.ApiKey
  plug GatewayWeb.RateLimiter
  plug GatewayWeb.DynamicRouter
end
