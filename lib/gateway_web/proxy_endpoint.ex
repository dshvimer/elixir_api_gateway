defmodule GatewayWeb.ProxyEndpoint do
  use Phoenix.Endpoint, otp_app: :gateway

  # plug Phoenix.LiveDashboard.RequestLogger,
  #   param_key: "request_logger",
  #   cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :proxy_endpoint]
  plug GatewayWeb.ApiKey
  plug GatewayWeb.RateLimiter
  plug GatewayWeb.DynamicRouter
  plug ReverseProxyPlug, upstream: "https://api.github.com/"
end
