IMAGE = reg.istry.cz/trz/go-1

all: build push

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)
