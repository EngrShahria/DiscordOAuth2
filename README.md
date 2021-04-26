# DiscordOAuth2 by Xinshou

To create an OAuth2 module and access the Discord stuff via API, you sure will need this!

Discord OAuth2 Link: https://discord.com/developers/docs/topics/oauth2
First, you need to create an Application and enable OAuth2 [Discord Application](https://discord.com/developers/applications)

Then, you will need to set up your OAuth2 Object

```Lua
local DAuth = require("DiscordOAuth2")

local ClientData = {
  ClientID = --[[Your Client ID]]
  ClientSecret = --[[Your Client Secret]]
  redirect_uri = --[[Your redirect_uri]]
}

local Discord = DAuth:new(ClientData) --It will create everything that is needed. Already included the path.
```

You have successfully created your application OAuth2! But, there more!

To redirect to the link, you can generate the link.

```Lua
local options ={
  redirect_uri = --[[Your redirect_url
  scope = --[[ All listed Scopes. Example: "indentify guilds" ]]
}

local AuthURL = Discord:GenAuthLink(options)
```

#I will add more content/features soon!
