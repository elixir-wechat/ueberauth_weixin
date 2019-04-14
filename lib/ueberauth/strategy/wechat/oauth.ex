defmodule Ueberauth.Strategy.Wechat.OAuth do
  @moduledoc false

  use OAuth2.Strategy

  defp config do
    [
      strategy: __MODULE__,
      site: "https://api.weixin.qq.com",
      authorize_url: "https://open.weixin.qq.com/connect/oauth2/authorize",
      token_url: "https://api.weixin.qq.com/sns/oauth2/access_token"
    ]
  end

  def client do
    Application.fetch_env!(:ueberauth, __MODULE__)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
    |> put_serializer("text/plain", Jason)
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params) <> "#wechat_redirect"
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), params, headers)
  end

  def fetch_user(%{token: token} = client) do
    params = %{
      access_token: token.access_token,
      openid: token.other_params["openid"]
    }

    case OAuth2.Client.get!(client, "/sns/userinfo", [], params: params) do
      %{body: %{"errcode" => errcode, "errmsg" => errmsg}} ->
        {:error, %{code: errcode, reason: errmsg}}

      %{body: body} ->
        {:ok, body}
    end
  end

  @impl true
  def authorize_url(client, params) do
    client
    |> put_param(:response_type, "code")
    |> put_param(:scope, "snsapi_userinfo")
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
    |> put_param(:grant_type, "authorization_code")
    |> put_param(:code, code)
    |> put_param(:appid, client.client_id)
    |> put_param(:secret, client.client_secret)
    |> merge_params(params)
    |> put_headers(headers)
  end
end
