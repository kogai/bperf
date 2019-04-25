FROM golang:1.11.5

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

WORKDIR /go/src/github.com/kogai/app
ADD . /go/src/github.com/kogai/app
RUN dep ensure

CMD [ "go", "run", "main.go" ]
