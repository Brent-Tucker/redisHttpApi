local _m = {}

_m["redis_host"] = "127.0.0.1"
_m["redis_port"] = 6379
_m["redis_require_auth"] = "N"
_m["redis_auth_pass"] = "the_password_of_redis"

-- "Y" means enabling acl checking
_m["acl_check_enabled"] = "N"
_m["acl_check_url"] = "http://xxx.xxx.xxx.xxx/ESBServer/sysApi/checkACL"

return _m
