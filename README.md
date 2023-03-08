# PT-use-tool



## 0 介绍

（水平有限脚本粗糙, 作为学习记录）

功能已验证服务器类型：

| vendor | info                                 |
| ------ | ------------------------------------ |
| buyvm     | Linux localhost 5.10.0-11-amd64 #1 SMP Debian 5.10.92-2 (2022-02-28) x86_64 GNU/Linux |
| hosthatch | Linux localhost 4.19.0-21-amd64 #1 SMP Debian 4.19.249-2 (2022-06-30) x86_64 GNU/Linux|
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

⭐请切换到root用户使用

1# 更新与下载一些包

```shell
apt update -y && apt upgrade -y && apt install vim sudo tmux ufw git curl wget zip unzip net-tools -y && ufw --force enable && echo finish!
```
2# 下载本项目到 /root && 给予权限

```shell
git clone https://github.com/mustvvvics/PT-use-tool.git && chmod 777 /root/PT-use-tool/ptuse.sh
```

3# 设置alias指令，方便使用脚本

```shell
echo "alias ptuse='/root/PT-use-tool/ptuse.sh'" >> /root/.bashrc && source /root/.bashrc
```


⭐其中通过ufw管理暴露的端口（若不需要，则 apt install 中不安装 ufw）

```bash
# 启动ufw
ufw enable 
# 关闭ufw
ufw disable 
# 添加规则 放行80和443端口 用于域名解析
ufw allow 80
ufw allow 443
# 删除规则
# e.g.  ufw delete allow 80
# 查看当前设定的规则
ufw status
```



### 2.2 使用指南

#### 2.2.1 安装qbittorrent-nox  

1# default install   默认使用 9999 与 /root/Download/qbittorrent

```shell
ptuse -bq
```

2# use your port and save dir 
```shell
ptuse -p 11111 -s /root/Download -q
```


⭐现在你可以通过访问 ip:port ，来进入qbittorrent Web UI 。**默认账号admin 密码adminadmin 。**

⭐**请立刻登录并修改账号密码。**



#### 2.2.2 为qbittorrent Web UI 设置域名与ssl证书

⭐**请先进行域名解析。**

⭐**并将ssl证书的zip压缩包(nginx 版本)，使用XFTP等软件，或者使用scp命令，放在服务器的 

```bash
/root/PT-use-tool/config/nginxconfig/cert/certqbittorrent/
```

1# 配置证书 default set 

```shell
ptuse -b -z your_public_zones
```
2# 或使用你自己指定的端口 use your port
```shell
ptuse -p 11111 -n -z your_public_zones
```

⭐现在你可以通过访问你设置域名，来进入qbittorrent Web UI。



#### 2.2.3 docker flexget 的安装

1# docker flexget install
```shell
ptuse -d -f your_flexgetwebui_passward
```

⭐现在你可以通过访问 ip:5050 来进入flexget 设置 RSS 的页面进行rss的配置。

⭐默认账号为flexget，密码为你自己设置的your_flexgetwebui_passward。

⭐**同时记得修改qbittorrent Web UI 中的监控文件夹地址为：/root/.config/flexget/data**



#### 2.2.4 BaiduPCS-Go 安装

1# BaiduPCS-Go install
```shell
ptuse --baidu
```
2# 设置快捷指令
```shell
echo "alias baidu='/root/BaiduPCS/baidu/BaiduPCS-Go'" >> /root/.bashrc && source /root/.bashrc
```

BaiduPCS-Go使用指南 / operating guide : https://github.com/qjfoidnh/BaiduPCS-Go



#### 2.2.5 FolderMagic 安装

1# FolderMagic install, 请设置好自己的共享位置以及账号密码
```shell
ptuse -P 10001 -S /root/share -A FolderMagic_account -m FolderMagic_passward
```


如果需要用到域名访问。那么，

⭐**先进行域名解析。**

⭐**并将ssl证书的zip压缩包(nginx 版本)，放在服务器的 **

```bash
/root/PT-use-tool/config/nginxconfig/cert/certFolderMagic
```

注意与上面的qbittorrent 位置不同

1# set FolderMagic
```shell
ptuse -P 10001 -Z your_public_zones
```



#### 2.2.6 制作种子

1# 下载 transmission 以及设置tracker
```bash
ptuse -t your_pt_tracker
```
2# 创建种子文件 会生成 xxxxx.S01.1080p.WEB-DL.H264.AC3.torrent 
```bash
ptuse --trans xxxxx.S01.1080p.WEB-DL.H264.AC3
```
3# 查看一个文件的信息
```bash
mediainfo media_file_name
```


#### 2.2.7 卸载 remove

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

## 3 证书更新
1# 假设你的端口为9999, 你的域名为xxxxxx.com

2# 先把nginx证书的zip文件放置于当前目录下，并在当前目录下执行以下操作。

3# 对于qbittorrent
```shell
rm -rf /root/PT-use-tool/config/nginxconfig/cert/certqbittorrent/*zip && mv *.zip /root/PT-use-tool/config/nginxconfig/cert/certqbittorrent/ && ptuse -p 9999 -z xxxxxx.com
```
4# 对于FolderMagic（注意与上方区分大小写）
```shell
rm -rf /root/PT-use-tool/config/nginxconfig/cert/certFolderMagic/*zip && mv *.zip /root/PT-use-tool/config/nginxconfig/cert/certFolderMagic && ptuse -P 9999 -Z xxxxxx.com
```

5# 操作逻辑：删除当前旧目录zip，移动当前目录zip到指定目录，使用ptuse的功能去完成文件移动命名与更新

6# 会报错 ln: failed to create symbolic link '/etc/nginx/sites-enabled/FolderMagic.conf': File exists （因为之前使用ptuse已经执行过此操作）
7# 但只要 nginx -t 测试成功即可

## 4 所有功能选项

1# 显示帮助

```bash
ptuse -h
```



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

-t,--transmission-install                install transmission and set your pt tracker.  eg: ptuse -t your_pt_tracker

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

