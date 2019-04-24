FROM golang:1.11.5

WORKDIR /go/src/github.com/kogai/bperf
ADD . /go/src/github.com/kogai/bperf
RUN pwd

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

RUN dep ensure && \
  go build

CMD [ "go", "run", "main.go" ]
