defmodule Pigeon.HTTP_1 do
  require Logger

  def open(_uri, _port, _opts \\ []) do
    {:ok, self()}
  end

  def close(_conn) do
    :ok
  end

  def post(_conn, uri, path, headers, body) do
    url = "https://" <> uri <> "/" <> path
    case HTTPoison.post(url, body, headers) do
      {:ok, response} ->
        stream_id = :base64.encode(:erlang.term_to_binary(response))
        send(self(), {:END_STREAM, stream_id})
        {:ok, stream_id}
      {:error, _} = e ->
        e
    end
  end

  def receive(_conn, stream_id) do
    response = :erlang.binary_to_term(:base64.decode(stream_id))
    headers = response.headers ++ [
      {":status", Integer.to_string(response.status_code)}
    ]
    {:ok, {headers, response.body}}
  end

  def ping(_conn) do
    :ok
  end
end
