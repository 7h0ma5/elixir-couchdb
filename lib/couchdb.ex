defmodule Couchdb do
  def connect(host \\ "127.0.0.1", port \\ 5984, protocol \\ "http") do
    %Couchdb.Server{host: host, port: port, protocol: protocol}
  end
end
