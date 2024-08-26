SHELL:=/bin/bash

start:
	docker-compose up -d

stop:
	docker-compose down

shell:
	docker-compose exec app bash

bundle:
	docker-compose run --rm app bundle

test:
	docker-compose run --rm app rspec

coverage:
	docker-compose run --rm -e COVERAGE=1 app rspec
