# restHttpApi

## Requirements:

1. OpenResty has been installed under /usr/local/openresty, please refer to http://www.openresty.org/ for details.

2. Redis has been installed and without authentication settings.


## Usage:

1. Modify the Redis settings in lua/appConfig.lua, the defaults are localhost and 6379.

2. Start the app by running the shell file ./startup.sh, please modify the execution permission if it can't start. Please refer to OpenResty's documentation for how to start the service if you're using Windows to run OpenResty.

3. There are two modes:
 * Single command mode, use one parameter "cmd", access the url *http://localhost:6699/redisHttpApi/redisApi?cmd=set('key1','value1')* to set the value of a key, and access the url *http://localhost:6699/redisHttpApi/redisApi?cmd=get('key1')* to retrieve the value of a key. You can use any Redis command, and please refer to *http://www.redis.io/commands* for details.
 * Batch commands mode, use two parameters "mode" and "cmds", the parameter "mode"'s value is "BATCH", and cmds is a JSON array of commands, such as ["set('key1', 'value1')", "get('key1')"]. The API urls are *http://localhost:6699/redisHttpApi/redisApi?mode=BATCH&cmds=["set('key1', 'value1')", "get('key1')"]*

4. In your applications, you can use above URLs to set and get values with Redis, and recommend HTTP POST to use the APIs.



