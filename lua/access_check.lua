local config = require("appConfig")

if config["acl_check_enabled"] ~= 'Y' then
  return
end

local utils = require "lib.utils"
local cjson = require "cjson"

local args

if (ngx.var.request_method == "POST") then
	ngx.req.read_body()
   args = ngx.req.get_post_args()
else
   args = ngx.req.get_uri_args()
end


if not args.access_token then
  ngx.say(cjson.encode(utils.getReturnResult("71","sorry, without access_token parameter")))
  return
end

local httpt = require "resty.http"
local httpc = httpt.new()
local res, err = httpc:request_uri(config["acl_check_url"], {
  method = "POST",
  body = "access_token=" .. args.access_token .. "&api_url=" .. ngx.var.uri,
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
})

if not res then
  ngx.say(cjson.encode(utils.getReturnResult("72","Error when do auth checking: " .. err)))
  return
end

local jsonData = cjson.decode(res.body)

if jsonData.errorCode ~= '00' then
  ngx.say(cjson.encode(utils.getReturnResult("73","Error when validating access_token: " .. jsonData.errorMessage)))
  return
end
