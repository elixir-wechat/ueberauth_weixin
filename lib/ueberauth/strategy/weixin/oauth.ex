defmodule Ueberauth.Strategy.Weixin.OAuth do
  @moduledoc false

  def authorize_url!(client, params) do
    OAuth2.Client.authorize_url!(client, params) <> "#wechat_redirect"
  end

  def get_token!(client, params, headers) do
    OAuth2.Client.get_token!(client, params, headers)
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

  defmacro __using__(opts) do
    authorize_url = Keyword.fetch!(opts, :authorize_url)

    quote do
      import unquote(__MODULE__)

      defp config do
        [
          strategy: Ueberauth.Strategy.Weixin.OAuth.AuthCode,
          site: "https://api.weixin.qq.com",
          token_url: "https://api.weixin.qq.com/sns/oauth2/access_token",
          authorize_url: unquote(authorize_url)
        ]
      end

      defp client do
        Application.fetch_env!(:ueberauth, __MODULE__)
        |> Keyword.merge(config())
        |> OAuth2.Client.new()
      end

      def authorize_url!(params \\ []) do
        authorize_url!(client(), params)
      end

      def get_token!(params \\ [], headers \\ []) do
        get_token!(client(), params, headers)
      end
    end
  end
end
