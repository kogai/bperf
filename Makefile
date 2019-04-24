DC := docker-compose

.PHONY: clean
clean:
	$(DC) stop
	$(DC) rm -f

db/run:
	$(DC) run --rm db psql -h postgres -U bperf
