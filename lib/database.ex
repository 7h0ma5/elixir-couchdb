defmodule CouchDB.Database do
  defstruct [:name, :server]

  alias CouchDB.Server

  def create(database) do
    database.server
    |> Server.put("/#{database.name}", "{}")
  end

  def destroy(database) do
    database.server
    |> Server.delete("/#{database.name}")
  end

  def all_docs(database, options \\ %{}) do
    database.server
    |> Server.get("/#{database.name}/_all_docs", options)
  end

  def get(database, id) do
    database.server
    |> Server.get("/#{database.name}/#{id}")
  end

  def view(database, design, view, options \\ %{}) do
    database.server
    |> Server.get("/#{database.name}/_design/#{design}/_view/#{view}", options)
  end

  def show(database, design, show, id, options \\ %{}) do
    database.server
    |> Server.get("/#{database.name}/_design/#{design}/_show/#{show}/#{id}", options)
  end

  def list(database, design, list, view, options \\ %{}) do
    database.server
    |> Server.get("/#{database.name}/_design/#{design}/_list/#{list}/#{view}", options)
  end

  def insert(database, body) do
    database.server
    |> Server.post("/#{database.name}", body)
  end

  def insert(database, id, body) do
    database.server
    |> Server.put("/#{database.name}/#{id}", body)
  end

  def bulk(database, body) do
    database.server
    |> Server.post("/#{database.name}/_bulk_docs", body)
  end

  def delete(database, id, rev) do
    database.server
    |> Server.delete("/#{database.name}/#{id}", %{rev: rev})
  end
end
