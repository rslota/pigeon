defmodule Pigeon.PushyWorker do
  @moduledoc """
    Handles all Pushy request and response parsing over an HTTP1.1 connection.
  """
  use Pigeon.GenericH2Worker, ping_interval: 60_000, http_client: Pigeon.HTTP_1
  alias Pigeon.GCM.NotificationResponse
  require Logger

  def default_name, do: :pushy_default

  def host(config) do
    config[:endpoint] || "api.pushy.me"
  end

  def port(config) do
    config[:port]     || 443
  end

  def socket_options(_config) do
    {:ok, []}
  end

  def encode_notification({_registration_ids, notification}) do
    notification
  end

  def req_headers(config, _notification) do
    [
      {"content-type", "application/json"},
      {"accept", "application/json"}
    ]
  end

  def req_path(config, _notification) do
    "push?api_key=#{config[:key]}"
  end

  defp parse_error(_notification, _headers, body) do
    {:ok, response} = Poison.decode(body)
    response["error"]
  end

  defp parse_response({registration_ids, payload}, _headers, body) do
    result = Poison.decode! body
    parse_result(registration_ids, result)
  end

  def parse_result(ids, result) do
    case result["success"] do
      true ->
        %Pigeon.GCM.NotificationResponse{ok: ids, message_id: result["id"]}
      false ->
        %Pigeon.GCM.NotificationResponse{error: ids}
    end
  end

  def error_msg(code, error) do
    Pigeon.GCMWorker.error_msg(code, error)
  end
end
