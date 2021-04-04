defmodule CouchDB.Server do
  defstruct [:host, :port, :protocol, :user, :password]

  @headers [{"content-type", "application/json; charset=utf-8"}]

  def database(server, name) do
    %CouchDB.Database{server: server, name: name}
  end

  def url(server, path, options \\ []) do
    query = if options == [], do: nil, else: URI.encode_query(options)
    URI.to_string(%URI{
      host: server.host,
      port: server.port,
      scheme: server.protocol,
      path: path,
      query: query
    })
  end

  def get(server, path, options \\ []) do
    url(server, path, options)
    |> HTTPoison.get(headers(server))
    |> handle_get
  end

  def post(server, path, body) do
    url(server, path, [])
    |> HTTPoison.post(body, headers(server))
    |> handle_post
  end

  def put(server, path, body) do
    url(server, path, [])
    |> HTTPoison.put(body, headers(server))
    |> handle_put
  end

  def delete(server, path, options \\ []) do
    url(server, path, options)
    |> HTTPoison.delete(headers(server))
    |> handle_delete
  end

  def replicate(server,  from, to, options \\ []) do
    body = Enum.into(options, %{})
    |> Map.merge(%{
      source: from,
      target: to
    })
    |> Poison.encode!

    url(server, "/_replicate", [])
    |> HTTPoison.post(body, headers(server))
    |> handle_post
  end

  defp headers(server) do
    if server.user && server.password do
      @headers ++ [auth_header(server.user, server.password)]
    else
      @headers
    end
  end

  defp auth_header(user, password) do
    encoded = Base.encode64("#{user}:#{password}")
    {"Authorization", "Basic #{encoded}"}
  end

  defp handle_get({:ok, %{status_code: 200, body: body}}), do: { :ok, body }
  defp handle_get({:ok, %{status_code: _, body: body}}), do: { :error, body }
  defp handle_get({:error, reason}), do: { :error, reason }


  defp handle_post({:ok, %{status_code: 200, body: body}}), do: { :ok, body }
  defp handle_post({:ok, %{status_code: 201, body: body}}), do: { :ok, body }
  defp handle_post({:ok, %{status_code: 202, body: body}}), do: { :ok, body }
  defp handle_post({:ok, %{status_code: _, body: body}}), do: { :error, body }
  defp handle_post({:error, reason}), do: { :error, reason }

  defp handle_put({:ok, %{status_code: 201, body: body}}), do: { :ok, body }
  defp handle_put({:ok, %{status_code: _, body: body}}), do: { :error, body }
  defp handle_put({:error, reason}), do: { :error, reason }

  defp handle_delete({:ok, %{status_code: 200, body: body}}), do: { :ok, body }
  defp handle_delete({:ok, %{status_code: _, body: body}}), do: { :error, body }
  defp handle_delete({:error, reason}), do: { :error, reason }
end
