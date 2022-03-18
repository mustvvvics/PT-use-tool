# PT-use-tool





## 0 介绍

（水平有限脚本粗糙, 作为学习记录）

功能已验证服务器类型：

| vendor | info                                 |
| ------ | ------------------------------------ |
| buyvm  | Debian 11 , amd64 , x86_64 GNU/Linux |
|        |                                      |


一个便捷的pt使用部署。自动完成以下功能： 

1.使用qbittorrent-nox进行下载和做种。

2.设置域名与ssl证书

3.使用docker版本的flexget进行rss订阅。

4.安装BaiduPCS-Go进行百度云盘上传下载。

5.使用FolderMagic搭建webdav服务。完成服务器硬盘到本地的映射。

6.使用transmission-create制作种子。

## 1 涉及的开源工具

十分感谢优秀开源者的贡献。

https://github.com/userdocs/qbittorrent-nox-static

https://github.com/qbittorrent/qBittorrent

https://github.com/wiserain/docker-flexget

https://github.com/qjfoidnh/BaiduPCS-Go

https://github.com/FolderMagic/FolderMagic

https://github.com/FastGitORG/document

https://github.com/chaifeng/ufw-docker

## 2 部署使用

### 2.1 一些准备

!请切换到root用户使用

```shell
# update and install some requirement and open the ufw
apt update -y && apt upgrade -y &&apt install vim sudo tmux ufw git curl wget zip unzip net-tools -y && ufw --force enable && echo finish!

# 下载本项目到/root
git clone https://github.com/mustvvvics/PT-use-tool.git

# set alias command 设置alias指令，方便使用脚本
echo "alias ptuse='/root/PT-use-tool/ptuse.sh'" >> /root/.bashrc && source /root/.bashrc
```

### 2.2 使用指南

#### 2.2.1 安装qbittorrent-nox  



```shell
# default install   默认使用 9999 and /root/Download/qbittorrent
ptuse -bq

# use your port and save dir 
ptuse -p 11111 -s /root/Download -q
```



现在你可以通过访问 ip:port ，来进入qbittorrent Web UI 。**默认账号admin 密码adminadmin 。**

**请立刻登录并修改账号密码。**

#### 2.2.2 为qbittorrent Web UI 设置域名与ssl证书 



**！！先进行域名解析。**

**！！并将ssl证书的zip压缩包(nginx 版本)，使用XFTP等软件，或者使用scp命令，放在服务器的 /root/PT-use-tool/config/nginxconfig/cert/certqbittorrent/**



```shell
# default set 
ptuse -b -z your_public_zones

# use your port
ptuse -p 11111 -n -z your_public_zones
```

现在你可以通过访问你设置域名，来进入qbittorrent Web UI。

#### 2.2.3 docker flexget 的安装

```shell
# docker flexget install
ptuse -d -f your_flexgetwebui_passward
```

现在你可以通过访问 ip:5050 来进入flexget 设置 RSS 的页面进行rss的配置。默认账号为flexget，密码为你自己设置的your_flexgetwebui_passward。

**同时记得修改qbittorrent Web UI 中的监控文件夹地址为：/root/.config/flexget/data**



#### 2.2.4 BaiduPCS-Go 安装

```shell
# BaiduPCS-Go install
ptuse --baidu
```

使用指南 / operating guide : https://github.com/qjfoidnh/BaiduPCS-Go



#### 2.2.5 FolderMagic 安装

请设置好自己的共享位置以及账号密码

```shell
# FolderMagic install
ptuse -P 10001 -S /root/share -A FolderMagic_account -m FolderMagic_passward
```



如果需要用到域名访问。那么，

**！！先进行域名解析。**

**！！并将ssl证书的zip压缩包(nginx 版本)，放在服务器的 /root/PT-use-tool/config/nginxconfig/cert/certFolderMagic**

注意与上面的qbittorrent 位置不同

```shell
# set FolderMagic
ptuse -P 10001 -Z your_public_zones
```

#### 2.2.6 卸载remove

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

## 3 功能选项

```shell
-b, --basic-install                      basic config,port:9999，save directory:/root/Download/qbittorrent

-p, --qbittorrent-port                   set qbittorrent-nox port, eg: ptuse -p 9999

-s, --qbittorrent-save                   set qbittorrent-nox save directory, eg: ptuse -s /root/Download/qbittorrent

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

