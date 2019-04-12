# Überauth Weixin

Wechat open platform OAuth2 strategy for Überauth.

## Installation

```elixir
def deps do
  {:ueberauth_weixin, "~> 1.0"}
end
```

## Usage

```elixir
config :ueberauth, Ueberauth,
  providers: [
    weixin: {Ueberauth.Strategy.Weixin, [uid_field: :unionid]}
  ]
  
config :ueberauth, Ueberauth.Strategy.Weixin.OAuth,
  client_id: "YOUR_APPID",
  client_secret: "YOUR_SECRET"
```

`uid` value in `%Ueberauth.Auth{}`depends on the `uid_field` option.

`uid_field` has two values: `:openid` and `:unionid`. Default: `:openid`.

## Config router.ex in Phoenix project

```elixir
scope "/auth", MyAppWeb do
  pipe_through :browser

  get "/:provider", AuthController, :request
  get "/:provider/callback", AuthController, :callback
end
```

## Workflow

1. Visit `/auth/weixin` to start the OAuth2 workflow

2. If authorization succeeds, it will redirect user back to `/auth/weixin/callback` with the `%Ueberauth.Auth{}` struct

```elixir
def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params) do
  %Ueberauth.Auth{provider: provider, uid: uid} = auth

  # other logic
end
```
3. If authorization fails, in my experiment, in my experiment, it will not redirect the user back.


## Ueberauth.Auth struct

```elixir
%Ueberauth.Auth{
  credentials: %Ueberauth.Auth.Credentials{
    expires: true,
    expires_at: 1554813400,
    other: %{
      "openid" => "oRvxY6DXNEdehn5sPypKvep9zyds",
      "unionid" => "o2oUsuOUzgNL-JSLtIp8b3FzkI-M"
    },
    refresh_token: "20_MT0uS2Zml9dqA03WsSdtsgUFTYGvWp7YSNrKmvzdVAyqrZv2_6uAvpHjauWAvY4GEbu-LAs7_QbSJ94d9y_BRw",
    scopes: ["snsapi_login"],
    secret: nil,
    token: "20_3wMtd0cEIkNm1spcQpdixg_14VbXOdEKoGVtkmUBSQDvqkWDEi6WozUVcw7fch92gAwK_Eyh0aO8_uUWts-9hg",
    token_type: "Bearer"
  },
  extra: %Ueberauth.Auth.Extra{
    raw_info: %{
      "city" => "Baoshan",
      "country" => "CN",
      "headimgurl" => "http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaELP0QPmPFD06qDibHBwWmEzibV3lr9PJufl0JDpeFicV2vg2uw2FLj7728KiaJeribZXWXIaM0WOpFlicAg/132",
      "language" => "zh_CN",
      "nickname" => "yejun.su",
      "openid" => "oRvxY6DXNEdehn5sPypKvep9zyds",
      "privilege" => [],
      "province" => "Shanghai",
      "sex" => 1,
      "unionid" => "o2oUsuOUzgNL-JSLtIp8b3FzkI-M"
    }
  },
  info: %Ueberauth.Auth.Info{
    description: nil,
    email: nil,
    first_name: nil,
    image: "http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaELP0QPmPFD06qDibHBwWmEzibV3lr9PJufl0JDpeFicV2vg2uw2FLj7728KiaJeribZXWXIaM0WOpFlicAg/132",
    last_name: nil,
    location: nil,
    name: "yejun.su",
    nickname: "yejun.su",
    phone: nil,
    urls: %{}
  },
  provider: :weixin,
  strategy: Ueberauth.Strategy.Weixin,
  uid: "o2oUsuOUzgNL-JSLtIp8b3FzkI-M"
}
```
