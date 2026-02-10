# Домашнее задание к занятию «Организация сети»
## Задание 1. Yandex Cloud
## Что нужно сделать

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
- Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
- Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
- Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.
## Выполнение заданий
## Решение 1
Готовим окружение (результаты в src)
```
https://github.com/Spardoks/Terraform.-Yandex-Cloud
https://github.com/Spardoks/TerraformIntro
# Terraform v1.11.4
# debian 12
```
Разворачиваем инфраструктуру
```
ssh-keygen -t ed25519 -f ./ed25519 -N ""
yc config profile activate sa-profile
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
cp .terraformrc ~/.terraformrc
cat > personal.auto.tfvars << EOF
token        = "${YC_TOKEN}"
cloud_id     = "${YC_CLOUD_ID}"
folder_id    = "${YC_FOLDER_ID}"
EOF
terraform init
terraform validate
terraform plan
terraform apply
```
<img width="630" height="775" alt="image" src="https://github.com/user-attachments/assets/ee70d518-f0ed-44e0-acb8-d07901fcf97a" />

Проверяем доступность

```
ssh -i ./ed25519 ubuntu@$(terraform output -raw public_vm_external_ip)

cat <<EOF > ~/.ssh/config
Host nat-bastion
    HostName $(terraform output -raw public_vm_external_ip)
    User ubuntu
    IdentityFile ./ed25519

Host private-vm
    HostName $(terraform output -raw private_vm_internal_ip)
    User ubuntu
    IdentityFile ./ed25519
    ProxyCommand ssh -W %h:%p nat-bastion
EOF

ssh private-vm

curl ifconfig.me
```
<img width="732" height="242" alt="image" src="https://github.com/user-attachments/assets/5ff6568e-482b-4439-9f08-5e2bd4471ede" />

<img width="590" height="288" alt="image" src="https://github.com/user-attachments/assets/f095deb0-a5ed-4566-9232-ebf66cedca19" />

Чистим все
```
terraform destroy
rm -rf ~/.ssh/config
```
