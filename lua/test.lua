-- get the sql command template
local httpt = require "lib.resty.http"
local httpc = httpt.new()
   
local res, err = httpc:request_uri(config["redis_api_url"] .. "?cmd=get('SQL_01')", {
   method = "GET"
})
   
ngx.log(ngx.ERR, "called clearExpiredReservations, return: ", res.body)

-- render the real sql command


-- query MySQL database


