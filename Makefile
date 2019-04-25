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
