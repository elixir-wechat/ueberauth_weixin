defmodule UeberauthWeixin.OAuth2.Strategy.AuthCode do
  @moduledoc false

  use OAuth2.Strategy

  @impl true
  def authorize_url(client, params) do
    client
    |> put_param(:response_type, "code")
    |> put_param(:appid, client.client_id)
    |> merge_params(params)
  end

  @impl true
  def get_token(client, params, headers) do
    {code, params} = Keyword.pop(params, :code, client.params["code"])

    unless code do
      raise OAuth2.Error, reason: "Missing required key `code` for `#{inspect(__MODULE__)}`"
    end

    client
    |> put_serializer("text/plain", Jason)
    |> put_param(:grant_type, "authorization_code")
    |> put_param(:code, code)
    |> put_param(:appid, client.client_id)
    |> put_param(:secret, client.client_secret)
    |> merge_params(params)
    |> put_headers(headers)
  end
end
