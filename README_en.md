# PT_use_en

## 0 Summary

A convenient PT use deployment.

Automatically complete the following functions：

1.Download and Seeding by qbittorrent-nox.

2.set Domain Name and ssl for your qbittorrent-nox serive

3.RSS by docker flexget.

4.Uploads and downloads with BaiduPCS-Go.

5.Build webdav by FolderMagic.

6.To make seeds by transmission-create.

## 1 Open source tools involved

Thanks to the excellent open source contributors.

https://github.com/userdocs/qbittorrent-nox-static

https://github.com/qbittorrent/qBittorrent

https://github.com/wiserain/docker-flexget

https://github.com/qjfoidnh/BaiduPCS-Go

https://github.com/FolderMagic/FolderMagic

https://github.com/FastGitORG/document

https://github.com/chaifeng/ufw-docker

## 2 USE

### 2.1 Some preparation

Please use root !

```shell
# update and install some requirement and open the ufw
apt update -y && apt upgrade -y &&apt install vim sudo tmux ufw git curl wget zip unzip net-tools -y && ufw --force enable && echo finish!

# set alias command to set alias
echo "alias ptuse='/root/PT_use/ptuse.sh'" >> /root/.bashrc && source /root/.bashrc
```

### 2.2 Use guide

#### 2.2.1 install qbittorrent-nox  

```shell
# default install   default use 9999 and /root/Download/qbittorrent
ptuse -bq

# if use your port and save dir 
ptuse -p 11111 -s /root/Download -q
```

Now you can enter qbittorrent Web UI by login 'ip:port'. The default account is admin , password is adminadmin . 

Please change the password as soon as possible.

#### 2.2.2 set Domain Name and SSL for your qbittorrent-nox serive



**！！First of all,please do DNS(domain name resolution) .**

**！！And then put your SSL .zip file (nginx version) in   /root/PT_use/config/nginxconfig/cert/certqbittorrent/**



```shell
# default set 
ptuse -b -z your_public_zones

# if use your port
ptuse -p 11111 -n -z your_public_zones
```

Now you can enter qbittorrent Web UI by login with 'your_public_zones'.

#### 2.2.3 docker flexget install

```shell
# docker flexget install
ptuse -d -f your_flexgetwebui_passward
```

Now you can enter flexget to set your RSS rules by login ip:5050。

The default account is flexget, password is your_flexgetwebui_passward.

#### 2.2.4 BaiduPCS-Go install

```shell
# BaiduPCS-Go install
ptuse --baidu
```

operating guide : https://github.com/qjfoidnh/BaiduPCS-Go

#### 2.2.5 FolderMagic install

```shell
# FolderMagic install
ptuse -P 10001 -S /root/share -A FolderMagic_account -m FolderMagic_passward
```

If you need domain name access,

then

**！！First of all,please do DNS(domain name resolution) .**

**！！And then put your SSL .zip file (nginx version) in   /root/PT_use/config/nginxconfig/cert/certFolderMagic**

```shell
# set FolderMagic Domain Name and SSL
ptuse -P 10001 -Z your_public_zones
```

#### 2.2.6 remove

```shell
# remove qbittorrent
# default remove
ptuse -b --remove-qbit

# if you use your port
ptuse -p 11111 --remove-qbit

# remove nginx
ptuse --remove-nginx

# remove docker 
ptuse --remove-docker

# remove flexget
ptuse --remove-flexget

# remove FolderMagic 
ptuse -P 10001 --remove-m

# remove transmission
ptuse --remove-trans
```

## 3 Option



```shell
-b, --basic-install                      basic config,port:9999，save directory:/root/Download/qbittorrent

-p, --qbittorrent-port                   set qbittorrent-nox port, eg: ptuse -p 9999

-s, --qbittorrent-save      			 set qbittorrent-nox save directory, eg: ptuse -s /root/Download/qbittorrent

-q, --qbittorrent-install                install qbittorrent-nox

-n, --nginx-install                      install nginx

-z, --qbittorrent-public-zones-ssl       set public zones and ssl certificate for your qbittorrent-nox serve, eg: ptuse -z google.com

-d, --docker-install                     install docker

-f, --flexget-install-config             Configure flexget

-P, --FolderMagic-port                   set FolderMagic port, eg: ptuse -P 9999

-S, --FolderMagic-save                   set FolderMagic save directory, eg: ptuse -S /root/Download/

-A, --FolderMagic-account                set FolderMagic account , eg: ptuse -A FolderMagic_account

-Z, --FolderMagic-public-zones-ssl       set public zones and ssl certificate for your FolderMagic serve, eg: ptuse -Z github.com

-m, --FolderMagic                        set FolderMagic passward and configure FolderMagic, eg: ptuse -m FolderMagic_passward

-t,--transmission-install                install transmission and set your pt tracker

--trans                                  use transmission-create to make torrent.  eg: ptuse --trans your_file_name

--baidu                                  install BaiduPCS-Go

--remove-trans                           remove transmission

--remove-qbit                            remove qbittorrent-nox

--remove-nginx                           remove nginx
 
--remove-docker                          remove docker

--remove-flexget                         remove flexget 

--remove-baidu                           remove BaiduPCS-Go

--remove-m                               remove FolderMagic

-h, --help                               show help

-v, --version                            show version
```

