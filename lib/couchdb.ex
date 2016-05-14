defmodule CouchDB do
  def connect(host \\ "127.0.0.1", port \\ 5984, protocol \\ "http", user \\ nil, password \\ nil) do
    %CouchDB.Server{
      host: host,
      port: port,
      protocol: protocol,
      user: user,
      password: password
    }
  end
end
