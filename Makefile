DC := docker-compose

.PHONY: clean
clean:
	$(DC) stop
	$(DC) rm -f

.PHONY: install
install:
	go get github.com/codegangsta/gin

db/run:
	$(DC) run -e PGPASSWORD=$(POSTGRES_PASSWORD) --rm db psql -h postgres -U $(DB_USER) -d $(DB_DATABASE)

db/reset:
	$(DC) run -e PGPASSWORD=$(POSTGRES_PASSWORD) --rm db psql -h postgres -U $(DB_USER) -c "drop database bperf"

db/size:
	$(DC) run -e PGPASSWORD=$(POSTGRES_PASSWORD) --rm db psql -h postgres -U $(DB_USER) -c "select pg_size_pretty( pg_database_size('bperf'))"
