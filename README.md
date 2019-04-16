# Überauth Weixin

Wechat OAuth2 strategies for Überauth.

Includes: 

* `:weixin` - Wechat open platform (https://open.weixin.qq.com)
* `:wechat` - Wechat official accounts platform (https://mp.weixin.qq.com)

## Installation

```elixir
def deps do
  {:ueberauth_weixin, "~> 1.0"}
end
```

## Usage

### Config router.ex in Phoenix project

```elixir
scope "/auth", MyAppWeb do
  pipe_through :browser

  get "/:provider", AuthController, :request
  get "/:provider/callback", AuthController, :callback
end
```

### Config strategies

* Wechat open platform

  ```elixir
  config :ueberauth, Ueberauth,
    providers: [
      weixin: {Ueberauth.Strategy.Weixin, [uid_field: :unionid]}
    ]

  config :ueberauth, Weixin,
    client_id: "YOUR_APPID",
    client_secret: "YOUR_SECRET"
  ```

* Wechat official accounts platform

  ```elixir
  config :ueberauth, Ueberauth,
    providers: [
      wechat: {Ueberauth.Strategy.Wechat, [uid_field: :unionid]}
    ]

  config :ueberauth, Wechat,
    client_id: "YOUR_APPID",
    client_secret: "YOUR_SECRET"
  ```

> Option `uid_field` has two values: `:openid` and `:unionid`. Default: `:openid`. 
  `uid` in `%Ueberauth.Auth{}`depends on this option.

## Workflow

1. Visit `/auth/:provider` to start the OAuth2 workflow

2. If authorization succeeds, it will redirect user back to `/auth/:provider/callback` with the `%Ueberauth.Auth{}` struct

```elixir
def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params) do
  %Ueberauth.Auth{provider: provider, uid: uid} = auth

  # other logic
end
```
3. If authorization fails, in my experiment, in my experiment, it will not redirect the user back.

## Ueberauth.Auth struct for :weixin strategy

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

## Ueberauth.Auth struct for :wechat strategy

```elixir
%Ueberauth.Auth{
  credentials: %Ueberauth.Auth.Credentials{
    expires: true,
    expires_at: 1555289733,
    other: %{"openid" => "oi00OuKAhA8bm5okpaIDs7WmUZr4"},
    refresh_token: "20_7mjDBge3fRkdYkhkfBa2P-1HuhaZV3rg7BXFPNX4XUgG3fyuPTgI9GtcYbn8-vPp5mwKuvVDXbULlLKuhbWEgERjKG8E-3vkr1OflkEafKs",
    scopes: ["snsapi_userinfo"],
    secret: nil,
    token: "20_r3UTxXsaApzjSVW7w611ObJBfAUj0_8TjH1PHpT0gVxC3L1C5qkYPZv4ke9aMrsexIu7qwibcdqSMMjg-Krz6gbT7l7a64YVlot4TdcrZpA",
    token_type: "Bearer"
  },
  extra: %Ueberauth.Auth.Extra{
    raw_info: %{
      "city" => "Baoshan",
      "country" => "CN",
      "headimgurl" => "http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaELbibcX7pqYNlNy97Ipgu4B7E3FzxIcEnOKnPM1AOBEicqZq0l4xqque9iboicc9lbDictrGCCxzW3fgUg/132",
      "language" => "zh_CN",
      "nickname" => "yejun.su",
      "openid" => "oi00OuKAhA8bm5okpaIDs7WmUZr4",
      "privilege" => [],
      "province" => "Shanghai",
      "sex" => 1
    }
  },
  info: %Ueberauth.Auth.Info{
    description: nil,
    email: nil,
    first_name: nil,
    image: "http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaELbibcX7pqYNlNy97Ipgu4B7E3FzxIcEnOKnPM1AOBEicqZq0l4xqque9iboicc9lbDictrGCCxzW3fgUg/132",
    last_name: nil,
    location: nil,
    name: "yejun.su",
    nickname: "yejun.su",
    phone: nil,
    urls: %{}
  },
  provider: :wechat,
  strategy: Ueberauth.Strategy.Wechat,
  uid: "oi00OuKAhA8bm5okpaIDs7WmUZr4"
}
```
