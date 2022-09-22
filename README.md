## Quickstart
```bash
# This will start with an in memory database.

$ docker run -p 3567:3567 -d registry.supertokens.io/supertokens/supertokens-mongodb
```

## Configuration
You can use your own `config.yaml` file as a shared volume or pass the key-values as environment variables. 

If you do both, only the shared `config.yaml` file will be considered.
  
#### Using environment variable
Available environment variables
- **Core**
	- API\_KEYS
	- SUPERTOKENS\_HOST
	- SUPERTOKENS\_PORT
	- ACCESS\_TOKEN\_VALIDITY
	- ACCESS\_TOKEN\_BLACKLISTING
	- ACCESS\_TOKEN\_SIGNING\_KEY\_DYNAMIC
	- ACCESS\_TOKEN\_SIGNING\_KEY\_UPDATE\_INTERVAL
	- REFRESH\_TOKEN\_VALIDITY
	- INFO\_LOG\_PATH
	- ERROR\_LOG\_PATH
    - MAX\_SERVER\_POOL\_SIZE
	- DISABLE\_TELEMETRY
	- BASE\_PATH
	- LOG\_LEVEL
	- IP\_ALLOW\_REGEX
	- IP\_DENY\_REGEX
- **MongoDB:**	
	- MONGODB\_CONNECTION\_URI
	- MONGODB\_DATABASE\_NAME
	- MONGODB\_COLLECTION\_NAMES\_PREFIX
  

```bash
docker run \
	-p 3567:3567 \
	-e MONGODB_CONNECTION_URI="mongodb://root:root@192.168.1.2:27017" \
	-d registry.supertokens.io/supertokens/supertokens-mongodb
```

#### Using custom config file
- In your `config.yaml` file, please make sure you store the following key / values:
  - `core_config_version: 0`
  - `host: "0.0.0.0"`
  - `mongodb_config_version: 0`
  - `info_log_path: null` (to log in docker logs)
  - `error_log_path: null` (to log in docker logs)
- The path for the `config.yaml` file in the container is `/usr/lib/supertokens/config.yaml`

```bash
docker run \
	-p 3567:3567 \
	-v /path/to/config.yaml:/usr/lib/supertokens/config.yaml \
	-d registry.supertokens.io/supertokens/supertokens-mongodb
```

## Logging
- By default, all the logs will be available via the `docker logs <container-name>` command.
- You can setup logging to a shared volume by:
	- Setting the `info_log_path` and `error_log_path` variables in your `config.yaml` file (or passing the values asn env variables).
	- Mounting the shared volume for the logging directory.

```bash
docker run \
	-p 3567:3567 \
	-v /path/to/logsFolder:/home/logsFolder \
	-e INFO_LOG_PATH=/home/logsFolder/info.log \
	-e ERROR_LOG_PATH=/home/logsFolder/error.log \
	-e MONGODB_CONNECTION_URI="mongodb://root:root@localhost:27017" \
	-d registry.supertokens.io/supertokens/supertokens-mongodb
```

## Database setup
- You do not need to ensure that the MongoDB database has started before this container is started. During bootup, SuperTokens will wait for ~1 hour for a MongoDB instance to be available.
- If ```MONGODB_CONNECTION_URI``` is not provided, then SuperTokens will use an in memory database.