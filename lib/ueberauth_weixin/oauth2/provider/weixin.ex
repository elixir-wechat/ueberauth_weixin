defmodule UeberauthWeixin.OAuth2.Provider.Weixin do
  @moduledoc false

  defp config do
    [
      strategy: UeberauthWeixin.OAuth2.Strategy.AuthCode,
      site: "https://api.weixin.qq.com",
      authorize_url: "https://open.weixin.qq.com/connect/qrconnect",
      token_url: "https://api.weixin.qq.com/sns/oauth2/access_token",
      scope: "snsapi_login"
    ]
  end

  def client do
    Application.fetch_env!(:ueberauth, Weixin)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
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
end
