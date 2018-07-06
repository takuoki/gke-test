FROM golang:1.9

# prepare SSH Key for git download
RUN echo "[url \"git@github.com:\"]\n\tinsteadOf = https://github.com/" >> /root/.gitconfig
RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no " > /root/.ssh/config
ADD ./.ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa

# add src
RUN apt-get update
ADD . /go/src/app
ADD ./lib /go/src/github.com/takuoki/gke-test/lib

# download dependency lib
WORKDIR /go/src/app
RUN go-wrapper download
RUN go-wrapper install

# compile for scratch
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

FROM scratch
COPY --from=0 /go/src/app/main .
ENV PORT 8080
CMD ["./main"]