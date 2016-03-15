local redis = require "lua.lib.redis"
local utils = require "lua.lib.utils"

red = redis:new()

local config = require("lua.appConfig")

red:set_timeout(1000) -- 1 sec

local cjson = require "cjson"

local ok, err = red:connect(config["redis_host"], config["redis_port"])
if not ok then
	ngx.say(cjson.encode(utils.getReturnResult("01","Failed to connect: " .. err )))
   return
end

local args

if (ngx.var.request_method == "POST") then
	ngx.req.read_body()
   args = ngx.req.get_post_args()
else
   args = ngx.req.get_uri_args()
end

-- parameter checking

if args.mode == "BATCH" then
	if not args.cmds then
		ngx.say(cjson.encode(utils.getReturnResult("05","No cmds parameter when in batch mode.")))
   	return
	end
else
	if not args.cmd then
		ngx.say(cjson.encode(utils.getReturnResult("04","No cmd parameter.")))
		return
	end
end


-- end of parameter checking

local res, err

if args.mode == "BATCH" then
	local cmds = cjson.decode(args.cmds)

	if not cmds then
		ngx.say(cjson.encode(utils.getReturnResult("06","Cmds parameter is not in JSON format.")))
   	return
	end

	res, err = red:init_pipeline()

	for _, command in ipairs(cmds) do
		res, err = utils.eval("red:" .. command)
	end

	res, err = red:commit_pipeline()	
else
	res, err = utils.eval("red:" .. args.cmd)
end

if not res then
	returnResult["errorCode"] = "02"
	if not err then
		ngx.say(cjson.encode(utils.getReturnResult("02","Some errors occured!")))
	else
		ngx.say(cjson.encode(utils.getReturnResult("02","Some errors occured: " .. err)))
	end
	return
end

ngx.say(cjson.encode(utils.getReturnResult("00", nil, res)))

-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
local ok, err = red:set_keepalive(10000, 100)
if not ok then
	ngx.say(cjson.encode(utils.getReturnResult("03","Failed to set keepalive: " .. err)))
   return
end

