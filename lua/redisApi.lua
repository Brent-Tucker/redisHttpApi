local redis = require "lua.lib.redis"
local utils = (require "lua.lib.utils"):new()

red = redis:new()

local config = require("lua.appConfig")

red:set_timeout(1000) -- 1 sec

local ok, err = red:connect(config["redis_host"], config["redis_port"])
if not ok then
	returnResult["errorCode"] = "01"
	returnResult["errorMessage"] = "failed to connect: " .. err
   ngx.say(cjson.encode(returnResult))
   return
end

local cjson = require "cjson"

local args

if (ngx.var.request_method == "POST") then
	ngx.req.read_body()
   args = ngx.req.get_post_args()
else
   args = ngx.req.get_uri_args()
end


local returnResult = {errorCode="00", errorMessage="", returnObject=""}

-- parameter checking

if not args.cmd then
   returnResult["errorCode"] = "04"
   returnResult["errorMessage"] = "No cmd parameter."
   ngx.say(cjson.encode(returnResult))
   return
end

-- end of parameter checking

local res, err

local args_length = 0

res, err = utils:eval("red:" .. args.cmd)

if not res then
	returnResult["errorCode"] = "02"
	if not err then
		returnResult["errorMessage"] = "Some errors occured!"
	else
		returnResult["errorMessage"] = "Some errors occured: " .. err
	end
   ngx.say(cjson.encode(returnResult))
   return
end

returnResult["errorCode"] = "00"
returnResult["returnObject"] = res

ngx.say(cjson.encode(returnResult))

-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
local ok, err = red:set_keepalive(10000, 100)
if not ok then
	returnResult["errorCode"] = "03"
	returnResult["errorMessage"] = "failed to set keepalive: " .. err
   return
end

