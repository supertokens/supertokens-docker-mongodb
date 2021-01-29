set -e
# build image
docker build -t supertokens-mongodb:circleci .

test_equal () {
    if [[ $1 -ne $2 ]]
    then
        printf "\x1b[1;31merror\x1b[0m in $3\n"
        exit 1
    fi
}

no_of_running_containers () {
    docker ps -q | wc -l
}

test_hello () {
    message=$1
    STATUS_CODE=$(curl -I -X GET http://127.0.0.1:3567/hello -o /dev/null -w '%{http_code}\n' -s)
    if [[ $STATUS_CODE -ne "200" ]]
    then
        printf "\x1b[1;31merror\xd1b[0m in $message\n"
        exit 1
    fi
}

test_session_post () {
    message=$1
    STATUS_CODE=$(curl -X POST http://127.0.0.1:3567/recipe/session -H "Content-Type: application/json" -d '{
        "userId": "testing",
        "userDataInJWT": {},
        "userDataInDatabase": {},
        "enableAntiCsrf": true
    }' -o /dev/null -w '%{http_code}\n' -s)
    if [[ $STATUS_CODE -ne "200" ]]
    then
        printf "\x1b[1;31merror\xd1b[0m in $message\n"
        exit 1
    fi
}

# start mongodb server
docker run -e DISABLE_TELEMETRY=true --rm -d -p 27017:27017 --name mongodb -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=root mongo

sleep 26s

# setting network options for testing
OS=`uname`

NETWORK_OPTIONS="-p 3567:3567 -e MONGODB_CONNECTION_URI=mongodb://root:root@$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1):27017"
printf "\nmongodb_connection_uri: \"mongodb://root:root@$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1):27017\"\n" >> $PWD/config.yaml

#---------------------------------------------------
# start with no options
docker run -e DISABLE_TELEMETRY=true --rm -d --name supertokens supertokens-mongodb:circleci --no-in-mem-db 

sleep 10s

test_equal `no_of_running_containers` 1 "start with no options"

#---------------------------------------------------
# start with no network options, but in mem db
docker run -e DISABLE_TELEMETRY=true -p 3567:3567 --rm -d --name supertokens supertokens-mongodb:circleci

sleep 17s

test_equal `no_of_running_containers` 2 "start with no network options, but in mem db"

test_hello "start with no network options, but in mem db"

test_session_post "start with no network options, but in mem db"

docker rm supertokens -f

#---------------------------------------------------
# start with no params
docker run -e DISABLE_TELEMETRY=true $NETWORK_OPTIONS --rm -d --name supertokens supertokens-mongodb:circleci --no-in-mem-db 

sleep 17s

test_equal `no_of_running_containers` 2 "start with no params"

test_hello "start with no params"

test_session_post "start with no params"

docker rm supertokens -f

#---------------------------------------------------
# start with mongodb connection_uri
docker run -e DISABLE_TELEMETRY=true $NETWORK_OPTIONS --rm -d --name supertokens supertokens-mongodb:circleci --no-in-mem-db

sleep 17s

test_equal `no_of_running_containers` 2 "start with mongodb connection_uri"

test_hello "start with mongodb connection_uri"

test_session_post "start with mongodb connection_uri"

docker rm supertokens -f

#---------------------------------------------------
# start by sharing config.yaml
docker run -e DISABLE_TELEMETRY=true $NETWORK_OPTIONS -v $PWD/config.yaml:/usr/lib/supertokens/config.yaml --rm -d --name supertokens supertokens-mongodb:circleci --no-in-mem-db

sleep 17s

test_equal `no_of_running_containers` 2 "start by sharing config.yaml"

test_hello "start by sharing config.yaml"

test_session_post "start by sharing config.yaml"

docker rm supertokens -f

# ---------------------------------------------------
# test info path
docker run -e DISABLE_TELEMETRY=true $NETWORK_OPTIONS -v $PWD:/home/supertokens -e INFO_LOG_PATH=/home/supertokens/info.log -e ERROR_LOG_PATH=/home/supertokens/error.log --rm -d --name supertokens supertokens-mongodb:circleci --no-in-mem-db

sleep 17s

test_equal `no_of_running_containers` 2 "test info path"

test_hello "test info path"

test_session_post "test info path"

if [[ ! -f $PWD/info.log || ! -f $PWD/error.log ]]
then
    exit 1
fi

docker rm supertokens -f

rm -rf $PWD/info.log
rm -rf $PWD/error.log
git checkout $PWD/config.yaml

docker rm mongodb -f

printf "\x1b[1;32m%s\x1b[0m\n" "success"
exit 0