# Tog1s_microservices

Tog1s microservices repository

## ДЗ № 13 Docker контейнеры. Docker под капотом.

- Установлен Docker 19.03.8
- Установлен docker-machine 0.16.0
- Запущен контейнер с образом hello-world
- Собран образ приложения reddit для docker hub
- Добавлен шаблон packer для сборки образа с Docker
- Добавлены ansible plyabooks для установки и деплоя приложения
- Добавлен terraform шаблон для развёртывания инстансов

### Задание со \*

Image несёт в себе "слепок системы", изменяя Image в конфигурации или в контейнеры мы создаём новые слои Image. Container это запущеный Image с набором нужных слоёв. В конфигурации ниже видно, что запускаемый Container ссылается на конкретный id Image. Полная выгрузка в docker-monolith/docker-1.log

### Задание со \*

Для развёртывания приложения reddit с помощью Docker в директории /docker-monolith/infra/ добавлены конфигурационые файлы ansible, packer, terraform.

Удаление контейнеров:

```bash
docker rm $(docker ps -a -q)
```

Команды для запуска docker-machine в YC:

```bash
yc compute instance create \
  --name docker-host \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
  --ssh-key ~/.ssh/appuser.pub
```

```bash
docker-machine create \
  --driver generic \
  --generic-ip-address=<id_adress> \
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/appuser \
  docker-host
```

```bash
eval $(docker-machine env docker-host)
```

## ДЗ № 14 Docker-образы. Микросервисы.

- Собрали образы на docker-host

```bash
docker pull mongo:latest
docker build -t tog1s/post:1.0 ./post-py
docker build -t tog1s/comment:1.0 ./comment
docker build -t tog1s/ui:1.0 ./ui
```

- Запустили приложение из нескольких микросервисов

```bash
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post tog1s/post:1.0
docker run -d --network=reddit --network-alias=comment tog1s/comment:1.0
docker run -d --network=reddit -p 9292:9292 tog1s/ui:1.0
```
### Задание со *

Перезаписываем переменные окружения при запуске контейнера

```bash
docker run -d --network=reddit --network-alias=new_post_db --network-alias=new_comment_db mongo:latest
docker run -d --env POST_DATABASE_HOST=new_post_db --network=reddit --network-alias=post tog1s/post:1.0
docker run -d --env COMMENT_DATABASE_HOST=new_comment_db --network=reddit --network-alias=comment tog1s/comment:1.0
docker run -d --env POST_SERVICE_HOST=post --env COMMENT_SERVICE_HOST=comment --network=reddit -p 9292:9292 tog1s/ui:1.0
```

- Уменьшили образ ui до 771 MB -> 449 MB

### Задание со *

Образы с версией 2.1 собраны на основе ruby2.6-alpine с очисткой dev инструментов, что привело к значительному сокращению размера.

```bash
❯ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
tog1s/comment       2.1                 b7589074978a        37 seconds ago      86.5MB
tog1s/ui            2.1                 ad8327f4f16f        13 minutes ago      88.6MB
tog1s/ui            2.0                 f57b5b9d8849        24 minutes ago      449MB
tog1s/ui            1.0                 6592be8486b7        53 minutes ago      771MB
tog1s/comment       1.0                 dfff85aee9c5        53 minutes ago      768MB
tog1s/post          1.0                 f4d84235d809        56 minutes ago      110MB
mongo               latest              aa22d67221a0        9 days ago          493MB
ubuntu              16.04               fab5e942c505        2 weeks ago         126MB
ruby                2.6-alpine          78349ac25912        6 weeks ago         50.4MB
ruby                2.2                 6c8e6f9667b2        2 years ago         715MB
python              3.6.0-alpine        cb178ebbf0f2        3 years ago         88.6MB
```


- Подключили volume к контейнеру с mongodb

```bash
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post tog1s/post:1.0
docker run -d --network=reddit --network-alias=comment tog1s/comment:2.1
docker run -d --network=reddit -p 9292:9292 tog1s/ui:2.1
```

Сервис работает без потери данных.

## ДЗ № 15 Docker: Сети, docker-compose.

- Разобрались с работой сети в Docker (none, host, bridge).
- Настроили разделение сетей на front_net, back_net.
- Разобрались с работой docker-proxy.
- Рассмотрели docker-compose.
- Создали docker-compose.yml для проекта.
- Добавили env файл для переменных проекта.
- Имя проекта можно задать через переменную окружения:

  ```bash
  COMPOSE_PROJECT_NAME=reddit
  ```

### Задание со \*

Создан src/docker-compose.override.yml для работы в debug/develop режимах. Файл можно переименовать и подключать при необходимости коммандой:

```bash
docker-compose up -f docker-compose.debug.yml
```

## ДЗ № 16 Gitlab CI. Построение процесса непрерывной интеграции

```bash
docker run -d --name gitlab-runner --restart always \
 -v /srv/gitlab-runner/config:/etc/gitlab-runner \
 -v /var/run/docker.sock:/var/run/docker.sock \
 gitlab/gitlab-runner:latest
```

```bash
 docker exec -it gitlab-runner gitlab-runner register \
    --url http://<ip>/ \
    --non-interactive \
    --locked=false \
    --name DockerRunner \
    --executor docker \
    --docker-image alpine:latest \
    --registration-token <token> \
    --tag-list "linux,xenial,ubuntu,docker" \
    --run-untagged
```
