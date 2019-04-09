defmodule Ueberauth.Strategy.Weixin do
  @moduledoc """
  OAuth2 login for https://open.weixin.qq.com.
  """

  use Ueberauth.Strategy, uid_field: :openid

  alias Ueberauth.Auth.{Credentials, Extra, Info}
  alias Ueberauth.Strategy.Weixin.OAuth

  def handle_request!(conn) do
    params =
      Map.put_new_lazy(conn.params, "state", fn ->
        Base.url_encode64(:crypto.strong_rand_bytes(32), padding: false)
      end)

    url = OAuth.authorize_url!(params)

    conn
    |> put_session(:weixin_state, params["state"])
    |> redirect!(url)
  end

  def handle_callback!(%Plug.Conn{params: %{"code" => code, "state" => given_state}} = conn) do
    state = get_session(conn, :weixin_state)

    if state == given_state do
      fetch_user(conn, code)
    else
      set_errors!(conn, [error("invalid_state", "Parameter state is invalid")])
    end
  end

  defp fetch_user(conn, code) do
    client = OAuth.get_token!(code: code)

    case OAuth.fetch_user(client) do
      {:ok, user} ->
        conn
        |> delete_session(:weixin_state)
        |> put_private(:weixin_user, user)
        |> put_private(:weixin_token, client.token)

      {:error, error} ->
        set_errors!(conn, [error(error.code, error.reason)])
    end
  end

  def uid(conn) do
    uid_field =
      conn
      |> option(:uid_field)
      |> to_string

    conn.private.weixin_user[uid_field]
  end

  def credentials(conn) do
    %Credentials{token: conn.private.weixin_token}
  end

  def extra(conn) do
    %Extra{raw_info: conn.private.weixin_user}
  end

  def info(conn) do
    user = conn.private.weixin_user

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
