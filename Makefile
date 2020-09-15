
DOCKER_USERNAME = tog1s
VPATH = src:monitoring

build: build_ui build_comment build_post build_prometheus build_alertmanager
build_ui: ui
	docker build -t $(DOCKER_USERNAME)/ui $^
build_comment: comment
	docker build -t $(DOCKER_USERNAME)/comment $^
build_post: post-py
	docker build -t $(DOCKER_USERNAME)/post $^
build_prometheus: prometheus
	docker build -t $(DOCKER_USERNAME)/prometheus $^
build_alertmanager: alertmanager
	docker build -t $(DOCKER_USERNAME)/alertmanager $^

push: push_comment push_ui push_post push_prometheus push_alertmanager
push_comment: comment
	docker push $(DOCKER_USERNAME)/comment
push_ui: ui
	docker push $(DOCKER_USERNAME)/ui
push_post: post-py
	docker push $(DOCKER_USERNAME)/post
push_prometheus: prometheus
	docker push $(DOCKER_USERNAME)/prometheus
push_alertmanager: alertmanager
	docker build -t $(DOCKER_USERNAME)/alertmanager $^
