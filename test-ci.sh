#!/bin/bash

env=$1
fails=""

inspect() {
    if [ $1 -ne 0 ]; then
        fails="${fails} $2"
    fi
}

# run server-side tests
server() {
    docker-compose -f docker-compose-dev.yml up -d --build
    docker-compose -f docker-compose-dev.yml run users python manage.py test
    inspect $? users
    docker-compose -f docker-compose-dev.yml run users flake8 project
    inspect $? users-lint
    docker-compose -f docker-compose-dev.yml run client npm test -- --coverage
    docker-compose -f docker-compose-dev.yml down
}

# run e2e tests
e2e() {
    docker-compose -f docker-compose-stage.yml up -d --build
    docker-compose -f docker-compose-stage.yml run users python manage.py recreate-db
    ./node_modules/.bin/cypress run --config baseUrl=http://localhost
    inspect $? e2e
    docker-compose -f docker-compose-$1.yml down
}

# run appropriate tests
if [[ "${env}" == "development" ]]; then
    echo "Running client & server-side tests!"
    dev
elif [[ "${env}" == "staging" ]]; then
    echo "Running e2e tests!"
    e2e stage
elif [[ "${env}" == "production" ]]; then
    echo "Running e2e tests!\n"
    e2e prod
else
    echo "Running client & server-side tests!"
    dev
fi

# return proper code
if [ -n "${fails}" ]; then
    echo "\n"
    echo "Tests failed: ${fails}"
    exit 1
else
    echo "\n"
    echo "Tests passed!"
    exit 0
fi
