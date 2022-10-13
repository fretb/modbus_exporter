FROM golang:alpine as builder
RUN apk add --no-cache build-base
ADD . /go/modbus_exporter
WORKDIR /go/modbus_exporter
RUN go mod vendor
RUN make build

FROM alpine:latest
RUN apk --no-cache add bash
WORKDIR /app
COPY --from=builder /go/modbus_exporter/modbus_exporter .
COPY --from=builder /go/modbus_exporter/modbus.yml .
ENTRYPOINT ["./modbus_exporter"]
EXPOSE 9602
