# restHttpApi

## Requirements:

1. OpenResty has been installed under /usr/local/openresty, please refer to http://www.openresty.org/ for details.

2. Redis has been installed and without authentication settings.


## Usage:

1. Modify the redis settings in lua/appConfig.lua, the defaults are localhost and 6379.

2. Start the app by running the shell file ./startup.sh, please modify the execution permission if it can't start. Please refer to OpenResty's documentation for how to start the service if you're using Windows to run OpenResty.

3. Access the url *http://localhost:6699/redisHttpApi/redisApi?cmd=set&p1=key1&p2=value1* to set the value of a key, and access the url *http://localhost:6699/redisHttpApi/redisApi?cmd=get&p1=key1* to retrieve the value of a key. You can use any Redis commands, and for details please refer to *http://www.redis.io/commands*.

4. In your applications, you can use above URLs to send and retrieve messages, the key URL parameters are "cmd" and "p1" or "p2", until "p4". It means if you want to use a redis command which use only one parameter, then you only need to pass the "cmd" and "p1" URL parameters. If you want to use a redis command which use three parameters, then you need to pass the "cmd", "p1", "p2" and "p3" parameters.



