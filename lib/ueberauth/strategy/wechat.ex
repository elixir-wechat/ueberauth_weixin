defmodule Ueberauth.Strategy.Wechat do
  @moduledoc """
  OAuth2 login for https://mp.weixin.qq.com.
  """

  @authorize_url "https://open.weixin.qq.com/connect/oauth2/authorize"

  use Ueberauth.Strategy, uid_field: :openid

  use Ueberauth.Strategy.Weixin.OAuth, authorize_url: @authorize_url

  alias Ueberauth.Auth.{Credentials, Extra, Info}

  @impl true
  def handle_request!(conn) do
    params =
      conn.params
      |> Map.put_new("redirect_uri", callback_url(conn))
      |> Map.put_new("scope", "snsapi_userinfo")

    redirect!(conn, authorize_url!(params))
  end

  @impl true
  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    client = get_token!(code: code)

    case fetch_user(client) do
      {:ok, user} ->
        conn
        |> put_private(:wechat_user, user)
        |> put_private(:wechat_token, client.token)

      {:error, error} ->
        set_errors!(conn, [error(error.code, error.reason)])
    end
  end

  @impl true
  def handle_cleanup!(conn) do
    conn
    |> put_private(:wechat_user, nil)
    |> put_private(:wechat_token, nil)
  end

  @impl true
  def uid(conn) do
    uid_field =
      conn
      |> option(:uid_field)
      |> to_string

    conn.private.wechat_user[uid_field]
  end

  @impl true
  def credentials(conn) do
    token = conn.private.wechat_token
    other_params = token.other_params
    {scope, other_params} = Map.pop(other_params, "scope")

    %Credentials{
      token: token.access_token,
      refresh_token: token.refresh_token,
      token_type: token.token_type,
      expires: token.expires_at != nil,
      expires_at: token.expires_at,
      scopes: [scope],
      other: other_params
    }
  end

  @impl true
  def extra(conn) do
    %Extra{raw_info: conn.private.wechat_user}
  end

  @impl true
  def info(conn) do
    user = conn.private.wechat_user

    %Info{
      name: user["nickname"],
      nickname: user["nickname"],
      image: user["headimgurl"]
    }
  end

  defp option(conn, key) do
    default = Keyword.get(default_options(), key)

    conn
    |> options()
    |> Keyword.get(key, default)
  end
end
