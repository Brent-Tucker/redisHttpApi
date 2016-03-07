local redis = require "lua.lib.redis"
local red = redis:new()

local config = require("lua.appConfig")

red:set_timeout(1000) -- 1 sec

-- or connect to a unix domain socket file listened
-- by a redis server:
--     local ok, err = red:connect("unix:/path/to/redis.sock")

local ok, err = red:connect(config["redis_host"], config["redis_port"])
if not ok then
   -- ngx.say("failed to connect: ", err)
	returnResult["errorCode"] = "01"
	returnResult["errorMessage"] = "failed to connect: " .. err
   ngx.say(cjson.encode(returnResult))
   return
end

local cjson = require "cjson"

local args = ngx.req.get_uri_args()

local returnResult = {errorCode="00", errorMessage="", returnObject=""}

local res, err

local args_length = 0

for _,_ in pairs(args) do
	args_length = args_length + 1
end

if (args_length == 2) then
	res, err = red:doCmd(args.cmd, args.p1)
end

if (args_length == 3) then
	res, err = red:doCmd(args.cmd, args.p1, args.p2)
end

if (args_length == 4) then
	res, err = red:doCmd(args.cmd, args.p1, args.p2, args.p3)
end

if (args_length == 5) then
	res, err = red:doCmd(args.cmd, args.p1, args.p2, args.p3, args.p4)
end

if not res then
	returnResult["errorCode"] = "01"
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
   -- ngx.say("failed to set keepalive: ", err)
	returnResult["errorCode"] = "02"
	returnResult["errorMessage"] = "failed to set keepalive: " .. err
   return
end

