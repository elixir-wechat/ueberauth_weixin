defmodule Ueberauth.Strategy.Weixin do
  @moduledoc """
  OAuth2 login for https://open.weixin.qq.com.
  """

  use Ueberauth.Strategy, uid_field: :openid

  alias Ueberauth.Auth.{Credentials, Extra, Info}

  @auth_url "https://open.weixin.qq.com/connect/qrconnect"
  @token_url "https://api.weixin.qq.com/sns/oauth2/access_token"
  @redirect_uri "http://beaver.ggrok.com/auth/weixin/callback"

  def handle_request!(conn) do
    appid = option(conn, :appid)

    url =
      "#{@auth_url}?appid=#{appid}&redirect_uri=#{@redirect_uri}&response_type=code&scope=snsapi_login#wechat_redirect"

    redirect!(conn, url)
  end

  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    appid = option(conn, :appid)
    secret = option(conn, :secret)

    url =
      "#{@token_url}?appid=#{appid}&secret=#{secret}&code=#{code}&grant_type=authorization_code"

    case HTTPoison.get!(url).body |> Ueberauth.json_library().decode!() do
      %{"access_token" => access_token, "openid" => openid} ->
        fetch_user(conn, access_token, openid)

      %{"errcode" => errcode, "errmsg" => errmsg} ->
        set_errors!(conn, [error(errcode, errmsg)])
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

  defp fetch_user(conn, token, openid) do
    url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{token}&openid=#{openid}"

    case HTTPoison.get!(url).body |> Ueberauth.json_library().decode!() do
      %{"errcode" => errcode, "errmsg" => errmsg} ->
        set_errors!(conn, [error(errcode, errmsg)])

      body ->
        conn
        |> put_private(:weixin_token, token)
        |> put_private(:weixin_user, body)
    end
  end

  defp option(conn, key) do
    default = Keyword.get(default_options(), key)

    conn
    |> options()
    |> Keyword.get(key, default)
  end
end
