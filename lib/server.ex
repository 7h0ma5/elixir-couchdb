defmodule CouchDB.Server do
  defstruct [:host, :port, :protocol]

  @headers [{"content-type", "application/json; charset=utf-8"}]

  def database(server, name) do
    %CouchDB.Database{server: server, name: name}
  end

  def url(server, path, options \\ []) do
    URI.to_string(%URI{
      host: server.host,
      port: server.port,
      scheme: server.protocol,
      path: path,
      query: URI.encode_query(options)
    })
  end

  def get(server, path, options \\ []) do
    url(server, path, options)
    |> HTTPoison.get!
    |> handle_get
  end

  def post(server, path, body) do
    url(server, path, [])
    |> HTTPoison.post!(body, @headers)
    |> handle_post
  end

  def put(server, path, body) do
    url(server, path, [])
    |> HTTPoison.put!(body, @headers)
    |> handle_put
  end

  def delete(server, path, options \\ []) do
    url(server, path, options)
    |> HTTPoison.delete!
    |> handle_delete
  end

  defp handle_get(%{status_code: 200, body: body}), do: { :ok, body }
  defp handle_get(%{status_code: ___, body: body}), do: { :error, body }

  defp handle_post(%{status_code: 201, body: body}), do: { :ok, body }
  defp handle_post(%{status_code: ___, body: body}), do: { :error, body }

  defp handle_put(%{status_code: 201, body: body}), do: { :ok, body }
  defp handle_put(%{status_code: ___, body: body}), do: { :error, body }

  defp handle_delete(%{status_code: 200, body: body}), do: { :ok, body }
  defp handle_delete(%{status_code: ___, body: body}), do: { :error, body }
end
