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
