# Tog1s_microservices
Tog1s microservices repository

## ДЗ № 13 Docker контейнеры. Docker под капотом.

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
  --generic-ip-address=130.193.51.44 \
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/appuser \
  docker-host
```

```bash
eval $(docker-machine env docker-host)
```
