# Überauth Weixin

> Weixin (open.weixin.qq.com) strategy for Überauth.

## Installation

```elixir
def deps do
  [
    {:ueberauth_weixin, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
config :ueberauth, Ueberauth,
  providers: [
    weixin: {Ueberauth.Strategy.Weixin,
             [appid: "YOUR_APPID",
              secret: "YOUR_SECRET",
              redirect_uri: "https://example.com/auth/weixin/callback",
              uid_field: :unionid # default is :openid
             ]}
  ]
```

## Ueberauth.Auth struct

```elixir
%Ueberauth.Auth{
  credentials: %Ueberauth.Auth.Credentials{
    expires: nil,
    expires_at: nil,
    other: %{},
    refresh_token: nil,
    scopes: [],
    secret: nil,
    token: "20_6S-d2pltLK8zzQfNvyzpu--yFH7sHdoKDgZRbvLbhlkTaRYhdg2z2bkh1aj1n7_TqEbsLE8DrU6D4yBtFHSuZQ",
    token_type: nil
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
  uid: "o2oUsuOUzgNL-JSLtIp8b3FzkI-M" # it depends on the :uid_field option, default value is from :openid.
}
```
