local utils = require "lib.utils"
local cjson = require "cjson"

local args

if (ngx.var.request_method == "POST") then
   ngx.req.read_body()
   args = ngx.req.get_post_args()
else
   args = ngx.req.get_uri_args()
end

if not args.templateStr then
   ngx.say(cjson.encode(utils.getReturnResult("01","No templateStr parameter.")))
   return
end

if not args.templateValues then
   ngx.say(cjson.encode(utils.getReturnResult("02","No templateValues parameter.")))
   return
end

local templateValues = cjson.decode(args.templateValues)

if not templateValues then
  	ngx.say(cjson.encode(utils.getReturnResult("03","Parameter templateValues is not in valid JSON format.")))
  	return
end

local template = require "resty.template"

local t = template.compile(args.templateStr, templateValues, true)

ngx.say(cjson.encode(utils.getReturnResult("00",nil,t(templateValues))))

