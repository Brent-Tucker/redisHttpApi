local mysql = require "resty.mysql"
local cjson = require "cjson"
local utils = require "lib.utils"

local config = require("appConfig")

local args

if (ngx.var.request_method == "POST") then
   ngx.req.read_body()
   args = ngx.req.get_post_args()
else
   args = ngx.req.get_uri_args()
end

-- parameter checking

if not args.sqlCmd then
   ngx.say(cjson.encode(utils.getReturnResult("04","No sqlCmd parameter.")))
   return
end

-- end of parameter checking


local db,err = mysql:new()
if not db then
   ngx.say(cjson.encode(utils.getReturnResult("01","Failed to instantiate mysql: " .. err )))
   return
end

db:set_timeout(1000)

ngx.say(config["dbHost"])
ngx.say(config["dbPort"])
ngx.say(config["dbName"])
ngx.say(config["dbUser"])
ngx.say(config["dbPassword"])

local ok, err, errno, sqlstate = db:connect {
   host = config["dbHost"],
   port = config["dbPort"],
   database = config["dbName"],
   user = config["dbUser"],
   password = config["dbPassword"],
   max_packet_size = 1024 * 1024
}

if not ok then
   ngx.say(cjson.encode(utils.getReturnResult("02","Failed to connect: ", err, ": ", errno, " ", sqlstate)))
   return
end

local res

res, err, errno, sqlstate = db:query(args.sqlCmd, 10)

if not res then
   ngx.say(cjson.encode(utils.getReturnResult("03","There are errors : ", err, ": ", errno, " ", sqlstate)))
   return
end

ngx.say(cjson.encode(utils.getReturnResult("00", nil, res)))

local ok, err = db:set_keepalive(10000, 100)
if not ok then
   ngx.say(cjson.encode(utils.getReturnResult("04","Failed to set keepalive: " .. err)))
   return
end

