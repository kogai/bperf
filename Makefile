DC := docker-compose

.PHONY: clean
clean:
	$(DC) stop
	$(DC) rm -f

.PHONY: install
install:
	go get github.com/codegangsta/gin

db/run:
	$(DC) run --rm db psql -h postgres -U bperf
