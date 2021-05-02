local object = require("core").Object

local http = require("coro-http")
local json = require("json")
local qs = require('querystring')
local request  = require("request")

local OAuth = object:extend()

function OAuth:initialize(opts)
    local opts = opts or {}

    if opts.ClientID == nil or opts.ClientSecret == nil then error("You must put ClientID/ClientSecret") end

    self.ClientID = opts.ClientID
    self.ClientSecret = opts.ClientSecret
    self.BaseURL = opts.BaseURL or "https://discord.com/api"
    self.authorizeUrl = opts.authorizeURL or "/oauth2/authorize"
    self.TokenURL = opts.TokenURL or "/oauth2/token"
    self.TokenURLRevoke = opts.TokenURLRevoke or "/oauth2/token/revoke"
    self.accessTokenName = "access_token"
	self.authMethod = "Bearer"
    self.AccessToken = nil
    self.RefreshToken = nil
    self.grant_type = opts.grant_type or "authorization_code"
    self.redirect_uri = opts.redirect_uri or "http://localhost"
end

function OAuth:GenAuthLink(params)
    local params = params or {}
    params["client_id"] = self.ClientID
    return self.BaseURL.. self.authorizeUrl .. "?" .. qs.stringify(params)
end

function OAuth:_getTokenURL()
    return self.BaseURL .. self.TokenURL
end

function OAuth:GetAccessTokens(code, callback)
    local params = {
        client_id = self.ClientID,
        client_secret = self.ClientSecret,
        grant_type = self.grant_type,
        redirect_uri = self.redirect_uri,
        code = code
    } 
    local ReqURL = self:_getTokenURL() .. "?" .. qs.stringify(params)
    request.post(ReqURL, {form = params, json = true}, function(err, tokens, response)
        if err and callback then
            callback(err, nil, nil, nil)
        end 
        self.AccessToken  = tokens.access_token
        self.RefreshToken = tokens.RefreshToken
        if callback then
            return callback(nil, self.AccessToken, self.RefreshToken, tokens)
        end
    end)
end

function OAuth:GetUserInfo(callback)
    if self.AccessToken == nil then
       return callback({error = true, reason = "No Access Token found in the cache."})
    end
    local Authorization = self.authMethod .. " " ..self.AccessToken  

    local reqURL = self.BaseURL .. "/users/@me"
    
    local read, res, any =  http.request("GET", reqURL, {{"Authorization",  Authorization}})
    local Body = json.decode(res)

    if Body.code == 0 then 
        return callback({error = true, reason = "Invalid Access Token, unable to get data"})
    end
    return callback(Body)  
end


return OAuth
