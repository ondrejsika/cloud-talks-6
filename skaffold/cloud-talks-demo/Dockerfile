FROM golang:1.15 as build
WORKDIR /build
COPY . .
ENV CGO_ENABLED=0
RUN go build -a -ldflags \
    '-extldflags "-static"' -o app

FROM scratch
WORKDIR /app
COPY --from=build /build/app .
CMD ["./app"]
EXPOSE 80