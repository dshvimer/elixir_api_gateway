defmodule Gateway.Proxy do
  def response({:ok, response}) do
    resp_headers =
      response.headers
      |> Enum.map(&downcase_header/1)
      |> Enum.reject(&unwanted_header?/1)

    {:ok, response.status_code, response.body, resp_headers}
  end

  def response({:error, reason}), do: {:error, "Error forwarding request: #{inspect(reason)}"}

  def forward({method, url, body, headers}) do
    %HTTPoison.Request{
      method: atom(method),
      url: url,
      body: body,
      headers: process_headers(headers, url)
    }
    |> HTTPoison.request()
  end

  defp process_headers(headers, upstream) do
    %URI{host: host, port: port} = URI.parse(upstream)

    headers =
      headers
      |> Enum.map(&downcase_header/1)
      |> Enum.reject(&unwanted_header?/1)

    [{"host", "#{host}:#{port}"}] ++ headers
  end

  @hop_headers ~w(keep-alive transfer-encoding te connection trailer upgrade proxy-authorization proxy-authenticate)
  defp unwanted_header?({header, _}) when header in @hop_headers, do: true
  defp unwanted_header?({"host", _}), do: true
  defp unwanted_header?(_), do: false

  defp downcase_header({h, v}), do: {String.downcase(h), v}
  defp atom(method), do: method |> String.downcase() |> String.to_atom()
end
