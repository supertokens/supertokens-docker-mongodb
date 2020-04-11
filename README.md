## About this image

The following parameters are required to start the container:
- `dev` / `production` mode
- `config.yaml` environment variables (Configuration)
- License Key file or License Key ID


## `dev` / `production` mode
- The default value of this is `dev`
- This is the same as what the CLI expects. You can learn more about the differences [here](https://supertokens.io/docs/pro/cli/start)


## Configuration
You can use your own `config.yaml` file as a shared volume or pass the key-values as environment variables. 

If you do both, only the shared `config.yaml` file will be considered.
  
#### Using environment variable
Available environment variables
- **Core** [[click for more info](https://supertokens.io/docs/pro/configuration/core)]
	- COOKIE\_DOMAIN \[**required**\]
	- REFRESH\_API\_PATH \[**required**\]
	- SUPERTOKENS\_HOST
	- SUPERTOKENS\_PORT
	- ACCESS\_TOKEN\_VALIDITY
	- ACCESS\_TOKEN\_BLACKLISTING
	- ACCESS\_TOKEN\_PATH
	- ACCESS\_TOKEN\_SIGNING\_KEY\_DYNAMIC
	- ACCESS\_TOKEN\_SIGNING\_KEY\_UPDATE\_INTERVAL
	- ENABLE\_ANTI\_CSRF
	- REFRESH\_TOKEN\_VALIDITY
	- INFO\_LOG\_PATH
	- ERROR\_LOG\_PATH
	- COOKIE\_SECURE
    - MAX\_SERVER\_POOL\_SIZE
- **MongoDB:** [[click for more info](https://supertokens.io/docs/pro/configuration/database/mongodb)]	
	- MONGODB\_CONNECTION\_URI \[**required**\]
	- MONGODB\_DATABASE\_NAME
	- MONGODB\_KEY\_VALUE\_COLLECTION\_NAME
	- MONGODB\_SESSION\_INFO\_COLLECTION\_NAME
	- MONGODB\_PAST\_TOKENS\_COLLECTION\_NAME
- **License Key**: [See below]
	- LICENSE_KEY_ID
  

```bash
$ docker run \
	-p 3567:3567 \
	-e MONGODB_CONNECTION_URI=mongodb://root:root@localhost:27017 \
	-e COOKIE_DOMAIN=example.com \
	-e REFRESH_API_PATH=/example/refresh \
	-e LICENSE_KEY_ID=yourLicenseKeyID \
	-d supertokens/supertokens-mongodb dev
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
$ docker run \
	-p 3567:3567 \
	-v /path/to/config.yaml:/usr/lib/supertokens/config.yaml \
	-e LICENSE_KEY_ID=yourLicenseKeyID \
	-d supertokens/supertokens-mongodb dev
```

## License Key
You can get your license key from your [SuperTokens dashboard](https://supertokens.io/dashboard).


You can either share your `licenseKey` file, or provide the ID as an environment variable. We recommend providing the file since that way you can run the container without giving it internet access.

Please check this [link](https://supertokens.io/docs/pro/about-license-keys) to learn more about license keys.

#### Using environment variables
```bash
$ docker run \
	-p 3567:3567 \
	-e MONGODB_CONNECTION_URI=mongodb://root:root@localhost:27017 \
	-e COOKIE_DOMAIN=example.com \
	-e REFRESH_API_PATH=/example/path \
	-e LICENSE_KEY_ID=<your-license-key-id> \
	-d supertokens/supertokens-mongodb production
```

#### Using your `licenseKey` file
```bash
$ docker run \
	-p 3567:3567 \
	-e MONGODB_CONNECTION_URI=mongodb://root:root@localhost:27017 \
	-e COOKIE_DOMAIN=example.com \
	-e REFRESH_API_PATH=/example/path \
	-v /path/to/licenseKey:/usr/lib/supertokens/licenseKey \	
	-d supertokens/supertokens-mongodb dev
```

## Logging
- By default, all the logs will be available via the `docker logs <container-name>` command.
- You can setup logging to a shared volume by:
	- Setting the `info_log_path` and `error_log_path` variables in your `config.yaml` file (or passing the values asn env variables).
	- Mounting the shared volume for the logging directory.

```bash
$ docker run \
	-p 3567:3567 \
	-v /path/to/logsFolder:/home/logsFolder \
	-e INFO_LOG_PATH=/home/logsFolder/info.log \
	-e ERROR_LOG_PATH=/home/logsFolder/error.log \
	-e MONGODB_CONNECTION_URI=mongodb://root:root@localhost:27017 \
	-e COOKIE_DOMAIN=example.com \
	-e REFRESH_API_PATH=/example/path \
	-e LICENSE_KEY_ID=yourLicenseKeyId \
	-d supertokens/supertokens-mongodb production
```

## Database setup
- You do not need to ensure that the MongoDB database has started before this container is started. During bootup, SuperTokens will wait for ~1 hour for a MongoDB instance to be available.


## CLI reference
Please refer to our [documentation](https://supertokens.io/docs/pro/cli/overview) for this.