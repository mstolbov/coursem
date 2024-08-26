# README

To run application use `make start` command.

Swagger is accessible by URL - http://localhost/api-docs/

## Usefull commands

* `make start` - runs application in docker
* `make stop` - stops docker containers with application
* `make shell` - attach to the shell in ran application container
* `make bundle` - run bundle command in container
* `make test` - run tests
* `make coverage` - run tests with coverage report generation which is placed in coverage/index.html

## How to seed the DB with test data

```
> make start
> make shell
> rails db:seed
```
