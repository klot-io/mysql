ACCOUNT=klotio
IMAGE=mysql
VERSION?=0.3
NAME=$(IMAGE)-$(ACCOUNT)
VOLUMES=-v ${PWD}/data:/var/lib/mysql
ENVIRONMENT=-e MYSQL_ALLOW_EMPTY_PASSWORD='yes'
TILT_PORT=23306

.PHONY: cross build shell up down push install update remove reset tag untag

cross:
	docker run --rm --privileged multiarch/qemu-user-static:register --reset

build:
	docker build . -t $(ACCOUNT)/$(IMAGE):$(VERSION)

shell:
	docker run -it --rm --name=$(NAME) $(VOLUMES) $(ENVIRONMENT) $(ACCOUNT)/$(IMAGE):$(VERSION) sh

up:
	mkdir -p data
	echo "- op: replace\n  path: /spec/template/spec/volumes/0/hostPath/path\n  value: $(PWD)/data" > tilt/data.yaml
	kubectx docker-desktop
	-kubectl label node docker-desktop mysql.klot.io/storage=enabled
	tilt --port $(TILT_PORT) up

down:
	kubectx docker-desktop
	tilt down

push:
	docker push $(ACCOUNT)/$(IMAGE):$(VERSION)

install:
	kubectl create -f kubernetes/db.yaml

update:
	kubectl replace -f kubernetes/db.yaml

remove:
	-kubectl delete -f kubernetes/db.yaml

reset: remove install

tag:
	-git tag -a "v$(VERSION)" -m "Version $(VERSION)"
	git push origin --tags

untag:
	-git tag -d "v$(VERSION)"
	git push origin ":refs/tags/v$(VERSION)"
